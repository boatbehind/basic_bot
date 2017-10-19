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
    message = "vote average:8.2" + "release year:1994" + "cast:Tom Hanks, Robin Wright" +"overview:A man with a low IQ has accomplished great things in his life and been present during significant historic events - in each case, far exceeding what anyone imagined he could do. Yet, despite all the things he has attained, his one true love eludes him. 'Forrest Gump' is the story of a man who rose above his challenges, and who proved that determination, courage, and love are more important than ability."
  elsif body == "the foreigner"
    message = "https://www.google.com/imgres?imgurl=http%3A%2F%2Fcdn2us.denofgeek.com%2Fsites%2Fdenofgeekus%2Ffiles%2Fstyles%2Fmain_wide%2Fpublic%2F2017%2F06%2Fjackie-chan-the-foreigner.jpg%3Fitok%3Du3YHhXg6&imgrefurl=http%3A%2F%2Fwww.denofgeek.com%2Fus%2Fmovies%2Fthe-foreigner%2F265954%2Fthe-foreigner-trailer-jackie-chan-and-pierce-brosnan-get-angry-and-gritty&docid=ZJTYYZw7ptSHGM&tbnid=qzfaky-Cb5cwsM%3A&vet=10ahUKEwj8so7_gf3WAhUK7yYKHWPiDOUQMwhkKC8wLw..i&w=825&h=464&safe=strict&bih=781&biw=1354&q=theforeigner&ved=0ahUKEwj8so7_gf3WAhUK7yYKHWPiDOUQMwhkKC8wLw&iact=mrc&uact=8" +
"vote average:6.3
release year:2017
cast:Jackie Chan, Pierce Brosnan, Charlie Murphy
overview:Quan is a humble London businessman whose long-buried past erupts in a revenge-fueled vendetta when the only person left for him to love -- his teenage daughter -- dies in a senseless act of politically motivated terrorism. His relentless search to find the terrorists leads to a cat-and-mouse conflict with a British government official whose own past may hold the clues to the identities of the elusive killers.
This movie is on! Do you wanna see it?"
  elsif body == "yes"
    message = "where is you location?"
  elsif body == "akron"
    message = "Sorry, we didn't find any movies playing there. Let me know if you want to change your location."
  elsif body == "pittsburgh"
    message = "Here are some movies near Pittsburgh. Reply the number you want to go.
1. AMC Waterfront 22 https://www.google.com/maps/place/AMC+Waterfront+22/@40.4071416,-79.918737,17.78z/data=!4m5!3m4!1s0x8834ee27fe6dcbf7:0x4aa4f798ecfa3f70!8m2!3d40.406757!4d-79.91834
2. Hollywood Theater 3. AMC Mount Lebanon 6"
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
