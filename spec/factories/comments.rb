FactoryGirl.define do
  factory :comment do
    text { Faker::Lorem.paragraph(2, false, 2) }
    task { FactoryGirl.create(:task) }
  end

end
