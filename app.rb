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
url = 'https://api.themoviedb.org/3/search/movie?api_key=9ec125b878c86c1f6ce8ca3a234cda31&language=en-US&query='



configure :development do
  require 'dotenv'
  Dotenv.load
end



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
  elsif body[0] == "~"
    #findmovie
    #@movie = TmdbMovie.find keywords
    movie_name = body.delete("~")
    url = url + movie_name
    response = HTTParty.get(url)

    title = response["results"][0]["title"]
    vote_average = response["results"][0]["vote_average"]
    overview = response["results"][0]["overview"]
    vote_average = response["results"][0]["vote_average"]
    popularity = response["results"][0]["popularity"]
    answer = title + vote_average + popularity + overview

    message = answer.to_s

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
