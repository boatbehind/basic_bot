require "sinatra"
require 'sinatra/reloader' if development?

require 'twilio-ruby'

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
     message = "Hey! I'm Lumix, I could help you order movie ticekts. "
  elsif body == "Hi" || body == "Hello" || body == "Hey"
    message = " Hey! Tell me what movie do you like?"
  elsif body == "War movie"
    message = "We have Dunkirk and Hacksaw Ridge"
  elsif body == "Dunkirk"
      message = "Coll! This is Nolan's new movie. It talks about firece battel in World War2. When do you want to see it? "
  elsif body == "Tommorrow 5 pm"
    message = "Cool! The Manor will have a movie that time."
  elsif body == "How much is it"
      message = "8$, book right now?"
  elsif body = "OK"
    message = "Great! I just booked, do you want add it to calender?"
  elsif body = "Thanks"
    message = "You are welcome! I'm happy to talk aout this movie after you finishing it!"
  end

  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|
      m.body( message )
    end
  end


  content_type 'text/xml'
  twiml.to_s

end
