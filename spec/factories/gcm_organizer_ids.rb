FactoryGirl.define do
  factory :gcm_organizer_id do
    user factory: :student
    gcm { (1..10).map {(('1'..'9').to_a + ('A'..'Z').to_a)[rand(36)]}.join }
  end
end
