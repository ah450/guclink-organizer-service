# == Schema Information
#
# Table name: gcm_organizer_ids
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  gcm        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_gcm_organizer_ids_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_2192bdab35  (user_id => users.id)
#

# Google Cloud Messaging ids
class GcmOrganizerId < ActiveRecord::Base
  belongs_to :user
  validates :user, :gcm, presence: true
  validates :user, :gcm, uniqueness: true
end
