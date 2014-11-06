FactoryGirl.define do
  factory :task do
    title { Faker::Lorem.sentence }
    project { FactoryGirl.create(:project) }
    priority { project.tasks.count }
    user { FactoryGirl.create(:user) }
    completed { [true, false].sample }
  end

end
