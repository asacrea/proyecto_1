require "redis"
require "json"

class StaticPagesController < ApplicationController
  def home
  	hostname = Diplomat::Service.get('redis').Address
    port = Diplomat::Service.get('redis').ServicePort
  	redis = Redis.new(host: hostname, port: port, db: 0)
  	@micropost  = current_user.microposts.build if logged_in?
  	if params[:search]
  		if !@feed_items 
    		@feed_items = current_user.feed_search(params[:search]).paginate(page: params[:page]) if logged_in?
    		@feed_items = redis.set "users", @feed_items
    	else
    		@feed_items
    	end
  	else
  		if !@feed_items
	    	@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
	    	redis.set "users", @feed_items
	    else
	    	@feed_items
	    end 
  	end
  end

  def help
  end

  def about
  end
end
