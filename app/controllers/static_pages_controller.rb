require "redis"
require "json"

class StaticPagesController < ApplicationController
  def home
  	hostname = Diplomat::Service.get('redis').Address
    port = Diplomat::Service.get('redis').ServicePort
  	redis = Redis.new(host: hostname, port: port, db: 0)
  	@micropost  = current_user.microposts.build if logged_in?
  	if params[:search]
  		if !@redisVar 
    		@feed_items = current_user.feed_search(params[:search]).paginate(page: params[:page]) if logged_in?
    		@redisVar = redis.set "users", @feed_items
    	else
    		
    	end
  	else
    	@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
    	redis.set "users", @feed_items
  	end
  end

  def help
  end

  def about
  end
end
