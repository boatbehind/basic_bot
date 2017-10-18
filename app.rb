require "sinatra"
require 'sinatra/reloader' if development?
require 'twilio-ruby'
require 'spotlite'
require 'httparty'
require 'json'
require 'rubygems'
require 'ruby-tmdb'

enable :sessions

@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

#moviedb api
url = 'https://api.themoviedb.org/3/discover/movie?api_key=9ec125b878c86c1f6ce8ca3a234cda31&language=en&sort_by=vote_average.desc&certification_country=US&page=1&with_keywords='
response = HTTParty.get(url)
result=response.parsed_response


configure :development do
  require 'dotenv'
  Dotenv.load
end

movie_name = String.new

get "/" do
	404
end


get "/sms/incoming" do
  session["last_intent"] ||= nil

  session["counter"] ||= 1
  count = session["counter"]

  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip

  if session["counter"] == 1
    message = "Hey there, I'm Lumimd. I can share any information about any movie!"
  elsif body == "hello" || body == "hi" || body == "hey"
    message = "Hi! Please tell me the movie name."
  elsif body != nill
    keywords = body #findmovie
    @movie = TmdbMovie.find keywords
    result2 = url + keywords
    puts [:release_data][:overview][:vote_average]
    message = result[:release_data][:overview][:vote_average]


  else
    message = "I'm sorry, I didn't get that"
    media = nil
  end

  session["counter"] += 1

  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|
      m.body( message )
      unless media.nil?
        m.media( media )
      end
    end
  end


  content_type 'text/xml'
  twiml.to_s

end
