

RSpec.describe ProjectsController, :type => :controller do
  include Devise::TestHelpers
  let(:user) { FactoryGirl.create :user }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("index")      
    end

    it "returns user projects with tasks" do
      get :index, { format: 'json' }
      JSON.parse(response.body).each do |project|
        expect(project['user_id']).to match(user.id)
        project['tasks'].each do |task|
          expect(task['user_id']).to match(user.id)
        end
      end
    end

    it "loads some books into @projects" do
      get :index, { format: 'json' }
      expect(assigns(:projects)).to match(user.projects.includes(:tasks))
    end
  end

  describe "POST #create" do
    it "should return status 500 if error" do
      post :create, { project: { title: 'q' }, format: 'json' }
      expect(response).to have_http_status(500)
    end

    it "should create new project" do
      user.projects.destroy_all
      post :create, { project: { title: "New test project" }, format: 'json' }
      user.reload
      expect(user.projects.first.title).to match("New test project")
    end

    it "should return created project" do
      post :create, { project: { title: "New test project2" }, format: 'json' }
      expect(JSON.parse(response.body)['title']).to match("New test project2")
    end
  end

  describe "PATCH #update" do  
    it "should return status 200" do
      patch :update, { project: { title: 'New test title',
       id: user.projects.first.id }, id: user.projects.first.id, format: 'json'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should update project title" do
      project = user.projects.first
      patch :update, { project: { title: 'New test title2', id: project.id }, 
        id: user.projects.first.id, format: 'json' }
      project.reload
      expect(project.title).to match('New test title2')
    end
  end

  describe "DELETE #destroy" do  
    it "should return status 200" do
      delete :destroy, { id: user.projects.first.id, format: 'json'}
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "should delete project" do
      project = user.projects.first
      delete :destroy, { id: project.id, format: 'json'}
      user.reload
      expect(user.projects).not_to include(project)
    end
  end

end
