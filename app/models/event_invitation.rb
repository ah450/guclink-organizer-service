# == Schema Information
#
# Table name: event_invitations
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_invitations_on_event_id  (event_id)
#  index_event_invitations_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_9d17290119  (user_id => users.id)
#  fk_rails_f85852b8c8  (event_id => events.id)
#

class EventInvitation < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
end
