# == Schema Information
#
# Table name: reset_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :reset_token do
    user { FactoryGirl.create(:student) }
    token { SecureRandom.urlsafe_base64 }
  end
end
