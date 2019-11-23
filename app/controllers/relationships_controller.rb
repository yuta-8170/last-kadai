class RelationshipsController < ApplicationController
  before_action :require_user_logged_in
  def create
    user = User.find(params[:follow_id])
    current_user.follow(user)
    user.create_notification_follow!(current_user)
    flash[:success] = "フォローしました"
    redirect_to user
  end

  def destroy
    user = User.find(params[:follow_id])
    current_user.unfollow(user)
    flash[:danger] = "フォロー解除しました"
    redirect_to user
  end
end
