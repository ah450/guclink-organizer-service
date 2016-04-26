FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.sentence }
    description { Faker::Hipster.paragraph }
    start_date { Faker::Time.forward(23, :morning) }
    end_date  { Faker::Time.forward(23, :evening) }
    owner { FactoryGirl.create(:student) }
  end
end
