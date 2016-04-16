FactoryGirl.define do
  factory :schedule_slot do
    course nil
    location "MyString"
    day ""
    slot_num ""
    tutorial false
    lecture false
    lab false
  end
end
