require 'rails_helper'

RSpec.describe TasksController, :type => :controller do
  include Devise::TestHelpers
  let(:user) { FactoryGirl.create :user }

  before do
    sign_in user
  end

  describe "PATCH #update_task_priority" do
    it "should return status 200" do
      project = user.projects.first
      task = project.tasks.first
      patch :update_task_priority, { task: { id: task.id, project_id: project.id,
        priority: 3, format: 'json' }, id: task.id, project_id: project.id }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "returns tasks list" do
      project = user.projects.first
      task = project.tasks.first
      patch :update_task_priority, { task: { id: task.id, project_id: project.id,
        priority: 3, format: 'json' }, id: task.id, project_id: project.id }
      task.reload
      expect(task.priority).to match(3)
    end
  end

  describe "POST #create" do
    it "should return status 500 if error" do
      post :create, { task: { project_id: user.projects.first, 
        title: 'q' }, project_id: user.projects.first, format: 'json' }
      expect(response).to have_http_status(500)
    end

    it "should create new task" do
      project = user.projects.first
      project.tasks.destroy_all
      post :create, { task: { project_id: project.id, 
        title: 'New test task' }, project_id: project.id, format: 'json' }      
      project.reload
      expect(project.tasks.first.title).to match("New test task")
    end

    it "should return project tasks" do      
      post :create, { task: { project_id: user.projects.first.id, 
        title: "New test task2" }, project_id: user.projects.first.id, format: 'json' }
      expect(JSON.parse(response.body).map! { |t| t['title'] }).to  include("New test task2")
    end
  end

  describe "PATCH #update" do  
    it "should return status 200" do
      project = user.projects.first
      task_id = project.tasks.first.id
      patch :update, { task: { title: 'New test title', completed: true,
       id: task_id }, id: task_id, project_id: project.id, format: 'json'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should update project title" do
      project = user.projects.first
      task = project.tasks.first
      patch :update, { task: { title: 'New test title2', id: task.id }, 
        id: task.id, project_id: project.id, format: 'json' }
      task.reload
      expect(task.title).to match('New test title2')
    end

    it "should update task completion" do
      project = user.projects.first
      task = project.tasks.first
      task.update(completed: false)
      patch :update, { task: { completed: true, id: task.id }, 
        id: task.id, project_id: project.id, format: 'json' }
      task.reload
      expect(task.completed).to match(true)
    end    
  end

  describe "DELETE #destroy" do  
    it "should return status 200" do
      task = user.projects.first.tasks.first
      delete :destroy, { id: task.id, project_id: task.project_id, format: 'json'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should delete project" do
      project = user.projects.first
      task = project.tasks.first
      delete :destroy, { id: task.id, project_id: project.id, format: 'json'}
      project.reload
      expect(project.tasks).not_to include(task)
    end
  end
end
