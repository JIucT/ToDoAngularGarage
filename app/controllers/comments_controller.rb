class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = Comment.new({ text: params[:comment], file: params[:file],
      task_id: params[:task_id] })
    authorize! :create, comment
    if comment.save
      render json: comment.to_json(methods: [:file_full_url, :file_thumb_url])
    else
      render nothing: true, status: 500
    end      
  end

  def destroy
    comment = Comment.find(params[:id])
    authorize! :destroy, comment
    comment.destroy
    render nothing: true, status: 200
  end
end
