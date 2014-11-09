class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.includes(:tasks).includes(:comments).where(user_id: current_user.id).order("created_at DESC")
    @comment = Comment.new
    respond_to do |format|
      format.html
      format.json { render json: @projects.to_json(include: { tasks: { include: :comments }}) }
    end    
  end

  def create
    project = Project.new({ user_id: current_user.id, title: project_params[:title] })
    if project.save
      render json: project
    else
      render nothing: true, status: 500
    end
  end

  def update
    project = Project.find(project_params[:id])
    authorize! :update, project
    project.update(title: project_params[:title])
    render nothing: true, status: 200
  end

  def destroy
    project = Project.find(params[:id])
    authorize! :destroy, project
    project.destroy
    render nothing: true, status: 200
  end

private
  def project_params
    params.require(:project).permit(:title, :id)
  end

end
