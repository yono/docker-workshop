require 'sinatra'
require 'redis'

def resolv_redis?
  ENV['REDIS_PORT_6379_TCP_ADDR'] || system('ping redis -c 5')
end

def redis_host
  ENV['REDIS_PORT_6379_TCP_ADDR'] || 'redis'
end

if resolv_redis?
  redis = Redis.new host: redis_host, port: 6379

  get '/' do
    @messages = redis.lrange :messages, 0, 9
    erb :home
  end

  post '/messages' do
    message = params[:message]
    redis.lpush :messages, message
    redirect '/'
  end

  delete '/messages' do
    redis.del :messages
    redirect '/'
  end
else
  get '/' do
    'Hello Docker World!'
  end
end
