class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        @comment.user_id = current_user.id
        @comment.micropost_id = params[:micropost_id]
        @micropost = @comment.micropost
        
        if @comment.save
            @micropost.create_notification_comment!(current_user, @comment.id)
            flash[:success] = 'コメントしました'
            redirect_back(fallback_location: root_path)
        else
            flash[:danger] = 'コメントできません'
            redirect_back(fallback_location: root_path)
        end
    end
    
    # def destroy
    #   @comment = Comment.find(params[:id])
    #   @comment.destroy
    #   flash[:success] = 'コメントを削除しました。'
    #   redirect_back(fallback_location: root_path)
    # end
    
    private
    
    def comment_params
        params.require(:comment).permit(:content)
    end
end
