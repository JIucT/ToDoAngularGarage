FactoryGirl.define do
  factory :task do
    title { Faker::Lorem.sentence }
    project { FactoryGirl.create(:project) }
    priority { project.tasks.count }
    user { FactoryGirl.create(:user) }
    completed { [true, false].sample }
    deadline { Faker::Date.forward(Random.rand(100)) }

    after(:create) do |task|
      create_list(:comment, Random.rand(5)+1, task: task)
    end    
  end

end
