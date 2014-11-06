FactoryGirl.define do
  factory :project do
    title { Faker::Lorem.sentence }
    user { FactoryGirl.create(:user) }

    after(:create) do |project|
      create_list(:task, Random.rand(10)+4, project: project, user_id: project.user_id)
    end
  end
end
