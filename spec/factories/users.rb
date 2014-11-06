FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(9) }
    sign_in_count { Random::rand(359) }    

    after(:create) do |user|
      create_list(:project, Random.rand(3)+1, user: user)
    end
  end
end
