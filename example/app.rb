
require 'sinatra'

get '/' do
  erb :index
end

CITIES = {
  "United Kingdom" => %w(London Edinburgh Cardiff Belfast),
  "United States" => ["New York", "Washington D.C", "Seattle", "New Orleans"]
}

get '/cities/:id' do |id|
  result = <<-JAVASCRIPT
    {"items" : [#{CITIES[id].map {|c| c.inspect}.join(", ")}]}
  JAVASCRIPT
end

post '/submit' do
  "You chose the city #{params["city"]} in the country #{params["country"]}"
end