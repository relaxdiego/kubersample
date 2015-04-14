require 'sinatra'
require 'redis'

set :bind, '0.0.0.0'

get '/' do
    r = Redis.new
    @messages = r.smembers "messages"
    erb :index
end

post '/sign' do
    r = Redis.new
    r.sadd "messages", params['message']
    redirect '/'
end
