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

enable :sessions

class Field < ActiveRecord::Base
  validates :name, presence: true
  validates :body, presence: true #, length: { minimum: 1 }

  def update_body( new_body )
    self.body = new_body
  end
end

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
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

get_posts = client.posts "aaronmicahzick.tumblr.com", :type => "text"


##########################################################
######                   ROUTING                   #######
##########################################################


get "/" do
  @fields_map = {
    :about   => Field.where( section: "about" ).to_a,
    :work    => Field.where( section: "work" ).to_a,
    :gear    => Field.where( section: "gear" ).to_a,
    :contact => Field.where( section: "contact" ).to_a
  }

  @latest_post = get_posts["posts"][0]

  body = @latest_post["body"]

  if body.include? "<figure data-url"
    split_s = body.split "<figure data-url"

    i_1 = split_s[1].index( "www.youtube.com/embed/" ) + "www.youtube.com/embed/".length
    i_2 = split_s[1].index( "?feature=" ) - 1

    youtube_id = split_s[1][i_1..i_2]

    new_iframe = '<iframe id="youtube_iframe" src="https://www.youtube.com/embed/' + youtube_id + '?feature=oembed&amp;wmode=opaque" allowfullscreen="allowfullscreen" frameborder="0" height="405" width="540"></iframe>'
    body = split_s[0] + new_iframe
  end

  @latest_post["body"] = body

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

