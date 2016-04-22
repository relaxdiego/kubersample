#!/usr/bin/env ruby

require 'sinatra'
require 'redis'

set :bind, '0.0.0.0'

def redis_client
    opts = {
        :db => 'kubersample'
    }

    if ENV['REDIS_MASTER_SERVICE_HOST']
        opts[:host] = redis.hq.kubernetes.local
        opts[:port] = 6379
    end

    Redis.new(opts)
end

get '/' do
    begin
        r = redis_client
        @messages = r.smembers "messages"
    rescue Redis::CannotConnectError
        @messages = []
    end
    erb :index
end

post '/sign' do
    r = redis_client
    r.sadd "messages", params['message']
    redirect '/'
end
