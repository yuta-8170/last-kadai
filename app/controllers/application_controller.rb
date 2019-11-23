class ApplicationController < ActionController::Base
    
  include SessionsHelper
    
  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favposts = user.favorites.count
    @count_matchings = user.matchers.count
    @count_microposts = user.microposts.count
  end
end
