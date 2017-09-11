class StaticPagesController < ApplicationController
  def home
  	@micropost  = current_user.microposts.build if logged_in?
  	if params[:search]
    	@feed_items = current_user.feed_search(params[:search]).paginate(page: params[:page]) if logged_in?
  	else
    	@feed_items = current_user.feed.paginate(page: params[:page]) if logged_in?
  	end
  end

  def help
  end

  def about
  end
end
