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
  elsif body == "hello" || body == "hi" || body == "hey"
    message = "Hi! Tell me the movie name you like."
  elsif body == "dunkirk"
    message = "That's a great movie! Which part do you want to know?  Like: 'Director', 'Summary', 'Rate', 'Ticket', 'Show Time'"
  elsif body == "director"
    message = "It is directed by Christopher Nolan. My favorite derector!"
  elsif body == "summary"
    message = "It talks about Allied soldiers from Belgium, the British Empire and France are surrounded by the German Army, and evacuated during a fierce battle in World War II."
  elsif body == "rate"
    message = "8.4/10.0 from IMDb"
  elsif body == "ticket"
    message = "It's available at 5 pm at AMC. Do you wanna buy it?"
  elsif body == "buy"
    message = "Congratuations! You have bought this ticket!"
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
