require 'sinatra'
require "sinatra/reloader" if development?

require "twilio-ruby"

configure :development do
  require 'dotenv'
  Dotenv.load
end

get '/sms/incoming' do


end
