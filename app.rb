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
    message = "Hey there, I'm Lumimd. I can share any information about any movie!"
    #media = "https://media.giphy.com/media/13ZHjidRzoi7n2/giphy.gif"
  elsif body == "hello" || body == "hi" || body == "hey"
    message = "Hi! Tell me the movie name."
  elsif body == "The foreigner"
    message = "That's a great movie! Input 'Director', 'Summary', 'Rate', 'Ticket' to know this movie."
  elsif body == "director"
    message = "Martin Campbell"
  elsif body == "summary"
    message = "A humble businessman with a buried past seeks justice when his daughter is killed in an act of terrorism. A cat-and-mouse conflict ensues with a government official, whose past may hold clues to the killers' identities."
  elsif body == "rate"
    message = "7.4/10.0"
  elsif body == "ticket"
    message = "Are you in Pittsburgh?"
  elsif body == "Yes"
    message = "Here are some movies near Pittsburgh, PA. Let us know if you want to change your location. 1. Hollewood Theater 2. AMC Waterfront"
  elsif body == "Hollewood Theater"
    message = "It seems that there are no shows on 10-18-2017, type another date. (MM/DD/YYYY)"
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
