FactoryGirl.define do
  factory :student_fetched_info do
    user factory: :student
    guc_id_prefix 28
    guc_id_suffix 2239
    name "Stupido von Tawila"
  end
end
