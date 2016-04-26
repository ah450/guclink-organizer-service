FactoryGirl.define do
  factory :event_invitation do
    event
    user factory: :student
  end
end
