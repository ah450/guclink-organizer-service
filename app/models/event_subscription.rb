# == Schema Information
#
# Table name: event_subscriptions
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_event_subscriptions_on_user_id_and_event_id  (user_id,event_id)
#
# Foreign Keys
#
#  fk_rails_570823d7e3  (event_id => events.id)
#  fk_rails_5fbb25ac5c  (user_id => users.id)
#

class EventSubscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  validates :event, :user, presence: true
  validates :event_id, uniqueness: {scope: :user_id}
end
