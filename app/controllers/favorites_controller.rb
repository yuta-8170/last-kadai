class FavoritesController < ApplicationController
  before_action :require_user_logged_in
  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.like(micropost)
    micropost.create_notification_like!(current_user)
    flash[:success] = 'お気に入りしました'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unlike(micropost)
    flash[:danger] = 'お気に入りを解除しました'
    redirect_back(fallback_location: root_path)
  end
end
