require "sinatra"
require 'sinatra/reloader' if development?
require 'twilio-ruby'
require 'spotlite'
enable :sessions

@client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]


#moviedb api



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
  elsif body == "great" || body == "cool"
    message = "Yeah! Tell me the movie name you like."
  elsif body == "forrest gump"
    message =
"
🎫Vote average: 8.2

🕰Release year: 1994

🎬Cast:
Tom Hanks, Robin Wright

📘Overview:
A man with a low IQ has accomplished great things in his life, far exceeding what anyone imagined he could do. Yet, despite all the things he has attained. 'Forrest Gump' is the story of a man who rose above his challenges, and who proved that determination, courage, and love are more important than ability."
elsif body == "braveheart"
  message =
"
🎫Vote average: 7.7

🕰Release year: 1995

🎬Cast:
Mel Gibson, Sophie Marceau

📘Overview:
Enraged at the slaughter of Murron, his new bride and childhood love, Scottish warrior William Wallace slays a platoon of the local English lord's soldiers. This leads the village to revolt and, eventually, the entire country to rise up against English rule."

  elsif body == "films on showing"
   message ="
1. Geostorm
2. Happy Death Day
3. The Snow Man
4. The Foreigner
5. Only the Brave
Find more movies here:
https://www.fandango.com/moviesintheaters"
  elsif body == "4"
    message =
"
🎫Vote average: 6.3

🕰Release year: 2017

🎬Cast:
Jackie Chan, Pierce Brosnan, Charlie Murphy

📘Overview:
Quan is a London businessman whose long-buried past erupts in a vendetta when the only person left for him to love -- his daughter -- dies in a senseless act of terrorism. His relentless search to find the terrorists leads to a conflict with a British official whose own past may hold the clues to the identities of the elusive killers.

This movie is on!🍿🍿🍿
Do you wanna see it?"
  elsif body == "yes"
    message = "where is you location?"
  elsif body == "akron"
    message = "Sorry, we didn't find any movies playing there. Let me know if you want to change your location."
  elsif body == "pittsburgh"
    message = "Here are some theaters near Pittsburgh. Reply the number you want to go.
1. AMC Waterfront 22
2. Hollywood Theater
3. AMC Mount Lebanon 6
4. AMC South Hills Village 10
5. Cinemark Robinson Township and XD
Find More Here
https://www.fandango.com/15201_movieTimes?ticketedonly=true"
  elsif body == "1"
    message ="What date are you looking for? (MM/DD/YYYY)"
  elsif body == "10/25/2017"
    message ="Here we get some shows on 10/25/2017 at AMC Waterfront 22. Please check your tickets in this page. https://tickets.fandango.com/MobileExpress/Checkout?row_count=198402646&tid=aaosa&mid=193787&chainCode=AMC&source=MobileWeb&sdate=2017-10-25%2013:35"
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
