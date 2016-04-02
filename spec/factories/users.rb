# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string           not null
#  student         :boolean          not null
#  verified        :boolean          default(FALSE), not null
#  super_user      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    password { Faker::Internet.password }
    verified true

    factory :student do
      email { (0...10).map { ('a'..'z').to_a[rand(26)] }.join + '@student.guc.edu.eg' }
    end

    factory :teacher do
      email { (0...10).map { ('a'..'z').to_a[rand(26)] }.join + '@guc.edu.eg' }

      factory :super_user do
        super_user true
      end
    end
  end
end
