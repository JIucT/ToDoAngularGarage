RSpec.describe Task, :type => :model do
  let(:task) { FactoryGirl.create(:task) }

  context "validation" do
    it { expect(task).to validate_presence_of(:title) }
    it { expect(task).to validate_uniqueness_of(:title).scoped_to(:project_id) }
    it { expect(task).to ensure_length_of(:title) }
    it { expect(task).to validate_presence_of(:priority) }
    it { expect(task).to validate_presence_of(:project_id) }
    it { expect(task).to have_many(:comments).dependent(:destroy) }
  end

  context "relation" do
    it { expect(task).to belong_to(:project) }
    it { expect(task).to belong_to(:user) }
  end

  context "defaults" do
    it "should set priority and completeon" do
      new_task = Task.new(user: task.user)
      expect(new_task.priority).to match(0)
      expect(new_task.completed).to match(false)
    end
  end  
end
