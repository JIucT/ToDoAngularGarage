class TasksController < ApplicationController
  before_action :authenticate_user!

  def update_task_priority
    task = Task.find(task_params[:id])
    old_priority = task.priority
    new_priority = task_params[:priority]
    
    tasks = Task.where(project_id: task_params[:project_id])
    tasks.each do |task_item|
      if task_item.priority.between?(old_priority+1, new_priority)
        task_item.update( priority: task_item.priority.pred)
      elsif task_item.priority.between?(new_priority, old_priority)
        task_item.update( priority: task_item.priority.next)  
      end
    end
    task.update(priority: new_priority)
    tasks.reload
    render json: tasks
  end

  def create
    project_tasks = Project.find(task_params[:project_id]).tasks
    priority = project_tasks.count
    task = Task.new({ project_id: task_params[:project_id],
      title: task_params[:title], priority: priority })
    if task.save
      render json: task
    else
      render nothing: true, status: 500
    end
  end

  def update
    Task.find(task_params[:id]).update(task_params)
    render nothing: true, status: 200
  end

  def destroy
    task_to_delete = Task.find(params[:id])
    Task.where("project_id = ? and priority > ?", 
      params[:project_id], task_to_delete.priority).each do |task|
      task.update(priority: task.priority.pred)
    end
    task_to_delete.destroy
    render nothing: true, status: 200
  end

private
  def task_params
    params.require(:task).permit(:title, :project_id, :id, :completed, :priority)
  end  
end
