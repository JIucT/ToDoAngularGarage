class TasksController < ApplicationController
  before_action :authenticate_user!

  def update_task_priority
    task = Task.find(task_params[:id])
    authorize! :update, task
    old_priority = task.priority
    new_priority = task_params[:priority].to_i
    tasks = Task.recount_priorities(task_params[:project_id], old_priority, new_priority)
    task.update(priority: new_priority)    
    render json: tasks.to_json(include: { comments: { methods: [:file_full_url, :file_thumb_url] }})
  end

  def create
    project_tasks = Task.includes(:comments).where(project_id: task_params[:project_id])
    priority = project_tasks.count
    task = Task.new({ project_id: task_params[:project_id],
      title: task_params[:title], priority: priority, user_id: current_user.id })
    if task.save
      render json: project_tasks.to_json(include: { comments: { methods: 
        [:file_full_url, :file_thumb_url] }})
    else
      render nothing: true, status: 500
    end
  end

  def update
    task = Task.find(task_params[:id])
    authorize! :update, task
    task.update(task_params)
    render nothing: true, status: 200
  end

  def destroy
    task_to_delete = Task.find(params[:id])
    authorize! :destroy, task_to_delete
    Task.where("project_id = ? and priority > ?", 
      params[:project_id], task_to_delete.priority).each do |task|
      task.update(priority: task.priority.pred)
    end
    task_to_delete.destroy
    render nothing: true, status: 200
  end

private
  def task_params
    params.require(:task).permit(:title, :project_id, :id, :completed, :priority,
      :deadline)
  end  
end
