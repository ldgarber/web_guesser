require 'sinatra'
require 'sinatra/reloader'

secret = rand(100)

get '/' do
    "The secret number is #{secret}"
end
