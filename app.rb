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
    message = "Well, hey there! I'm Michael. You ready to get started? Type menu to choose what you want to know"
    #media = "https://media.giphy.com/media/13ZHjidRzoi7n2/giphy.gif"
  elsif body == "hello" || body == "hi" || body == "hey"
    message = "Hey there!"
  elsif body == "menu"
    message = "Type any of the following to learn about me! Name, age, height, college career, career goals, interests"
  elsif body == "name"
    message = "Michael Benjamin Brough"
  elsif body == "age"
    message = "25"
  elsif body == "height"
    message = "6' even"
  elsif body == "college career"
    message = "I graduated from BYU in April 2017 with a bachelors in Mechanical Engineering and a 3.84 GPA"
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
