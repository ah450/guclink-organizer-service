FactoryGirl.define do
  factory :student_registration do
    user factory: :student
    schedule_slot
  end
end
