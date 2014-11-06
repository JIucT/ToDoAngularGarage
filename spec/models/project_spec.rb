require 'rails_helper'

RSpec.describe Project, :type => :model do
  let(:project) { FactoryGirl.create(:project) }

  context "validation" do
    it { expect(project).to validate_presence_of(:title) }
    it { expect(project).to ensure_length_of(:title) }
  end

  context "relation" do
    it { expect(project).to belong_to(:user) }
    it { expect(project).to have_many(:tasks).dependent(:destroy) }

    it "should be able to create a new task" do
      task = project.tasks.new(FactoryGirl.attributes_for(:task, user: project.user))
      expect(task.save).to eq(true)
    end
  end

  context "defaults" do
    it "should set value for title" do
      new_project = Project.new(user: project.user)
      expect(new_project.title).to match("Enter project name")
    end
  end
end
