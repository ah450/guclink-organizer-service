FactoryGirl.define do
  factory :schedule_slot do
    course
    location "H9"
    day { rand(7) }
    slot_num { rand(6) }
    tutorial false
    lecture true
    lab false
    group "L1"
    name "CSEN 403"
    factory :tutorial do
      lecture false
      tutorial true
      location "C6.203"
      group "T9"
    end
    factory :lab do
      lab true
      lecture false
      location "C6.204"
      group "T9"
    end
  end
end
