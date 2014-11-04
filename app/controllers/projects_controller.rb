class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @projects = Project.includes(:tasks).where(user_id: current_user.id).order("created_at DESC")
    respond_to do |format|
      format.html
      format.json { render json: @projects.to_json(include: :tasks) }
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
    Project.update(project_params[:id], title: project_params[:title])
    render nothing: true, status: 200
  end

  def destroy
    Project.destroy(params[:id])
    render nothing: true, status: 200
  end

private
  def project_params
    params.require(:project).permit(:title, :id)
  end

end
