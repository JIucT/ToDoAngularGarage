require "cancan/matchers"

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.create(:user) }

  context "validation" do
    it { expect(user).to validate_presence_of(:email) }
    it { expect(user).to validate_uniqueness_of(:email) }
  end

  context "relation" do
    it { expect(user).to have_many(:projects).dependent(:destroy) }
    it { expect(user).to have_many(:tasks) }

    it "should be able to create a new project" do
      project = user.projects.new(FactoryGirl.attributes_for(:project))
      expect(project.save).to eq(true)
    end
  end
  
  context "abilities" do
    let(:ability) { Ability.new(user) }

    it { expect(ability).to be_able_to(:manage, user.projects.first) }
    it { expect(ability).not_to be_able_to(:read, Project.new(user: FactoryGirl.create(:user))) }

    it { expect(ability).to be_able_to(:manage, user.tasks.first) }
    it { expect(ability).not_to be_able_to(:read, Task.new(user: FactoryGirl.create(:user))) }    

    it { expect(ability).to be_able_to(:manage, user.tasks.first.comments.first) }
    it { expect(ability).not_to be_able_to(:read, Comment.new(task: FactoryGirl.create(:user).tasks.first)) }      
  end    
end
