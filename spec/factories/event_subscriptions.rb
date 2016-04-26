FactoryGirl.define do
  factory :event_subscription do
    event
    user factory: :student
  end
end
