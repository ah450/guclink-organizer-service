# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  type        :string           not null
#  title       :string           not null
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  topic       :string
#  sender_id   :integer
#  receiver_id :integer
#
# Indexes
#
#  index_notifications_on_receiver_id  (receiver_id)
#  index_notifications_on_sender_id    (sender_id)
#  index_notifications_on_type         (type)
#
# Foreign Keys
#
#  fk_rails_8780923399  (sender_id => users.id)
#  fk_rails_e57412e9b5  (receiver_id => users.id)
#

class TopicNotification < Notification
  validates :topic, presence: true
end
