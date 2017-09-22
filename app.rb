require 'sinatra'
require "sinatra/reloader" if development?

require "twilio-ruby"

configure :development do
  require 'dotenv'
  Dotenv.load
end


enable :sessions

# create a twilio client using your account info
@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

# create an endpoint to handle incoming requests from Twilio
get "/sms/incoming" do
  session["counter"] ||= 1
  body = params[:Body] || ""

  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|
      m.body( "You said: " + body + "\n It’s message number #{ session["counter"] } ")
   end
  end
  session["counter"] += 1
  content_type 'text/xml'
  twiml.to_s

end
