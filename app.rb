require "sinatra"
require 'sinatra/reloader' if development?
require 'twilio-ruby'
require 'spotlite'
enable :sessions

@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]



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
    message = "Hey there, I'm Lumix. I can share any information about any movie!"
    #media = "https://media.giphy.com/media/13ZHjidRzoi7n2/giphy.gif"
  elsif body == "hello" || body == "hi" || body == "hey"
    message = "Hi! Tell me the movie name."
  elsif body == "aaaa"
    message = "That's a great movie! Input 'Director', 'Summary', 'Rate', 'Ticket' to know this movie."
  elsif body == "director"
    message = "Nolan"
  elsif body == "summary"
    message = "War movie"
  elsif body == "rate"
    message = "8.7/10.0"
  elsif body == "ticket"
    message = "It's available today at asd"
  elsif body == "career goals"
    message = "I want to get involved in the product development of electromechanical devices used in everyday situations"
  elsif body == "interests"
    message = "I love playing volleyball, soccer, being social with friends, and watching movies"
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
