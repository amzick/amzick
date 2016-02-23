# app.rb

require "sinatra"
require "sinatra/activerecord"
require "./config/environments"

require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/form_helpers'

require 'haml'
require 'sass'
require 'compass'
require 'coffee-script'

require 'tumblr_client'

require './models/field'
require './models/work_item'

enable :sessions

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['amgz232', 'godehtybrik232']
  end

  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end

  include Rack::Utils
  alias_method :h, :escape_html
end


##########################################################
######                   TUMBLR                    #######
##########################################################


client = Tumblr::Client.new({
    :consumer_key => 'adPBCUStfJLM87SWP7a8DhkZoJMqMpUt8zuR9ohYs1TUKeF6oq',
    :consumer_secret => '3MgmCEMK24dAByB4EUyyk91w1cjYXUfFqZrFAGipd6axiYckOq',
    :oauth_token => 'ptmdNi2bW3QVemYEmARK03b4YFceBRnc8b8jOkXeNXEjo4PLMG',
    :oauth_token_secret => 'ozyLNwhEUZruJb5CEHHYDq053fgmNzKUyHaGDLL0XPa9cnDrdn'
  })

# get_posts = client.posts "aaronmicahzick.tumblr.com", :type => "text"


##########################################################
######                   ROUTING                   #######
##########################################################


get "/" do
  @fields_map = {
    :about   => Field.where( section: "about" ).order( :id ).to_a,
    :work    => Field.where( section: "work" ).order( :id ).to_a,
    :gear    => Field.where( section: "gear" ).order( :id ).to_a,
    :contact => Field.where( section: "contact" ).order( :id ).to_a
  }

  @work_items = WorkItem.all

  # get_posts = client.posts "aaronmicahzick.tumblr.com", :type => "text"
  # @latest_post = get_posts["posts"][0]

  get_post     = client.posts "aaronmicahzick.tumblr.com", id: "139856711107"
  @latest_post = get_post["posts"][0]

  if @latest_post
    body = @latest_post["body"] # ? @latest_post["body"] : @latest_post["comment"]

    if body.include?( "<figure" ) and body.include?( "<img" )
      @img_url = body[ body.index( "https://" ) + "https://".length...body.index( '.jpg' ) + ".jpg".length ]

      before = body.index( "<figure" )
      after  = body.index( "</figure>") + "</figure>".length

      new_body = body[0...before] + body[after...-1]

      @latest_post["body"] = new_body
    end
  end

  @title = "AM ZICK"
  haml :"fields/index"
end

post "/edit" do
  protected!
  new_info = params
  all_saves_successful = true

  new_info.each do |id, text|
    field = Field.find id

    if field.body != text
      field.update_body text
    end

    if field.save == false
      all_saves_successful = false
    end
  end

  if all_saves_successful
    redirect "/edit", :notice => 'Updated Successfully'
  else
    redirect "/edit", :error => 'Something went wrong. Try again.'
  end
end

get "/edit" do
  protected!
  @fields = Field.all

  @title = "Edit Page"
  haml :"fields/edit"
end

get "/blog" do
    @posts = get_posts["posts"]
    @total_posts = get_posts["total_posts"]
    @title = "Blog"
    haml :blog
end

get "/workitems/edit" do
  protected!
  @work_items = WorkItem.all
  haml :"work_items/edit"
end

get "/workitems/delete/:id" do
  protected!
  @work_item = WorkItem.find( params[:id] )

  if @work_item.destroy
    redirect "/workitems/edit", :notice => 'Updated Successfully'
  else
    redirect "/workitems/edit", :error => 'Something went wrong. Try again.'
  end
end

post "/workitems/edit" do
  protected!
  @work_item = WorkItem.new( params[:work_item] )

  if @work_item.save
    redirect "/workitems/edit", :notice => 'Updated Successfully'
  else
    redirect "/workitems/edit", :error => 'Something went wrong. Try again.'
  end 
end

put "/workitems/update" do
  protected!

  all_saves_successful = true

  params.each do | id |
    wi = WorkItem.find id[0]
    wi.update_self( id[1][0], id[1][1] ) # colummn, value

    if wi.save == false
      all_saves_successful = false
    end
  end

  if all_saves_successful
    return 200
  else
    return 500
  end
end

get "/:id.css" do
  sass "stylesheets/#{ params[ :id ] }".to_sym
end

get "/:id.js" do
  coffee "javascripts/#{ params[ :id ] }".to_sym
end

not_found { haml :'404' }
error { haml :'500' }

__END__

@@404
%h3 404
%p It seems this page is missing...

@@505
%h3 505 Error
%p Something's gone wrong...

