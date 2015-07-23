# app.rb

require "sinatra"
require "sinatra/activerecord"
require "./config/environments"

require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/form_helpers'

require 'haml'

enable :sessions

class Page < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true #, length: { minimum: 1 }

  def update_body( new_body )
    self.body = new_body
  end
end

get "/" do
  @pages_map = {
    :about   => Page.where( section: "about" ).to_a,
    :work    => Page.where( section: "work" ).to_a,
    :gear    => Page.where( section: "gear" ).to_a,
    :contact => Page.where( section: "contact" ).to_a,
  }

  @title = "Welcome"
  haml :"pages/index" 
end

helpers do
  def title
    if @title
      "#{@title}"
    else
      "Welcome."
    end
  end
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

post "/edit" do
  new_info = params
  all_saves_successful = true

  new_info.each do |id, text|
    page = Page.find id

    if page.body != text
      page.update_body text
    end

    puts "\n\nPage save ---- #{page.save}\n\n"

    if page.save == false
      all_saves_successful = false
    end
  end

  puts "\n\n Saves????? #{all_saves_successful}\n\n"

  if all_saves_successful
    redirect "/edit", :notice => 'Updated Successfully'
  else
    redirect "/edit", :error => 'Something went wrong. Try again.'
  end
end

get "/edit" do
  @pages = Page.all

  @title = "Edit Page"
  haml :"pages/edit" 
end

# post "/pages" do
#   @post = Post.new(params[:post])
#   if @post.save
#     redirect "posts/#{@post.id}", :notice => 'Congrats! Love the new post. (This message will disapear in 4 seconds.)'
#   else
#     redirect "posts/create", :error => 'Something went wrong. Try again. (This message will disapear in 4 seconds.)'
#   end
# end

# get "/posts/create" do
#   @title = "Create Post"
#   @post = Post.new
#   erb :"posts/create"
# end

# get "/pages/:id/edit" do
#   @page = Page.find params[ :id ]
#   @title = "Edit Form"
#   haml :"pages/edit"
# end

# get "/posts/:id" do 
#   @post = Post.find( params[:id] )
#   @title = @post.title
#   erb :"posts/view"
# end