class ProjectsController < ApplicationController
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: [:create, :update]

  def index
    @projects = Project.where(user_id: current_user.id).order("created_at DESC")
    respond_to do |format|
      format.html
      format.json { render json: @projects}
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

private
  def project_params
    params.require(:project).permit(:title, :id)
  end

end
