RSpec.describe CommentsController, :type => :controller do
  include Devise::TestHelpers
  let(:user) { FactoryGirl.create :user }

  before do
    sign_in user
  end

  describe "POST #create" do
    it "should return status 500 if error" do
      post :create, { project_id: user.projects.first.id, 
        task_id: user.projects.first.tasks.first.id, comment: '', format: 'json' }
      expect(response).to have_http_status(500)
    end

    it "should create new comment" do
      task = user.projects.first.tasks.first
      post :create, { project_id: task.project_id, task_id: task.id, 
        comment: "New created comment" }
      task.comments.reload
      
      expect(task.comments.pluck(:text)).to include("New created comment")
    end

    it "should return created comment" do
      task = user.projects.first.tasks.first
      post :create, { project_id: task.project_id, task_id: task.id, 
        comment: "New created comment2", format: 'json' }
      expect(JSON.parse(response.body)['text']).to match("New created comment2")
      expect(JSON.parse(response.body)['task_id']).to match(task.id)
    end
  end

  describe "DELETE #destroy" do  
    it "should return status 200" do
      task = user.projects.first.tasks.first
      delete :destroy, { project_id: task.project_id, task_id: task.id, 
        id: task.comments.first.id, format: 'json' }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should delete project" do
      task = user.projects.first.tasks.first
      comment = task.comments.first
      delete :destroy, { project_id: task.project_id, task_id: task.id, 
        id: comment.id, format: 'json' }
      task.reload
      expect(user.projects).not_to include(comment)
    end
  end

end
