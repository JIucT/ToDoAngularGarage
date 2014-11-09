class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = Comment.new({ text: params[:comment], file: params[:file],
      task_id: params[:task_id] })
    authorize! :create, comment
    if comment.save
      render json: comment
    else
      render nothing: true, status: 500
    end      
    # render json: comment
  end


end
