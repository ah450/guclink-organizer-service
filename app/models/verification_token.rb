# == Schema Information
#
# Table name: verification_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class VerificationToken < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true, uniqueness: true
  validates :token, presence: true
end
