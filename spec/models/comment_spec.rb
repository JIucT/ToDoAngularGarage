RSpec.describe Comment, :type => :model do
  let(:comment) { FactoryGirl.create(:comment) }

  context "validation" do
    it { expect(comment).to validate_presence_of(:text) }
    it { expect(comment).to validate_uniqueness_of(:text).scoped_to(:task_id) }
  end

  context "relation" do
    it { expect(comment).to belong_to(:task) }
  end

end
