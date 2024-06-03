class Admin::CommentsController < ApplicationController
  def index
    @users = User.includes(:comments) 
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to admin_comments_path, notice: 'コメントを削除しました。'
  end
end
