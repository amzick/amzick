# app.rb

require "sinatra"
require "sinatra/activerecord"
require "./config/environments"

require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/form_helpers'

require 'haml'

require 'tumblr'

enable :sessions

class Field < ActiveRecord::Base
  validates :name, presence: true
  validates :body, presence: true #, length: { minimum: 1 }

  def update_body( new_body )
    self.body = new_body
  end
end

get "/" do
  @fields_map = {
    :about   => Field.where( section: "about" ).to_a,
    :work    => Field.where( section: "work" ).to_a,
    :gear    => Field.where( section: "gear" ).to_a,
    :contact => Field.where( section: "contact" ).to_a
  }

  @title = "Welcome"
  haml :"fields/index"
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
  @fields = Field.all

  @title = "Edit Page"
  haml :"fields/edit"
end

client = Tumblr::Client.new({
  :consumer_key => 'adPBCUStfJLM87SWP7a8DhkZoJMqMpUt8zuR9ohYs1TUKeF6oq',
  :consumer_secret => '3MgmCEMK24dAByB4EUyyk91w1cjYXUfFqZrFAGipd6axiYckOq',
  :oauth_token => 'ptmdNi2bW3QVemYEmARK03b4YFceBRnc8b8jOkXeNXEjo4PLMG',
  :oauth_token_secret => 'ozyLNwhEUZruJb5CEHHYDq053fgmNzKUyHaGDLL0XPa9cnDrdn'
})

get_posts = client.posts(:hostname => "aaronmicahzick.tumblr.com", :api_key => "adPBCUStfJLM87SWP7a8DhkZoJMqMpUt8zuR9ohYs1TUKeF6oq", :limit => 10)

#Initialize the posts fetch beforehand, pass the found posts into /blog
posts = []
total_posts = 0
get_posts.perform do |response|
    if response.success?
        parsed_response = response.parse
        total_posts = parsed_response["response"]["blog"]["posts"]
        puts parsed_response
        posts =  parsed_response["response"]["posts"]
    end
end

get "/blog" do
    @posts = posts
    @total_posts = total_posts
    @title = "Blog"
    haml :blog
end