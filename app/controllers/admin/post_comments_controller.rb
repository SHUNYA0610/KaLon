class Admin::PostCommentsController < ApplicationController
  def destroy
    comment = PostComment.find(params[:id])
    comment.destroy
    redirect_to request.referer
  end
end