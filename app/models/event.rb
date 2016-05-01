# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :string           not null
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  num_likes   :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  private     :boolean          default(FALSE), not null
#  user_id     :integer
#  topic_id    :string           not null
#
# Indexes
#
#  index_events_on_created_at  (created_at)
#
# Foreign Keys
#
#  fk_rails_0cb5590091  (user_id => users.id)
#

class Event < ActiveRecord::Base
  validates :title, :description, :start_date, :end_date, presence: true
  validates :private, inclusion: [true, false]
  validates :owner, presence: true
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :event_subscriptions, dependent: :destroy
  has_many :event_invitations, dependent: :destroy
  include Cacheable
  before_save :gen_topic_id

  def gen_topic_id
    self.topic_id = "event_#{id}"
  end

  def like
    Event.increment_counter(:num_likes, id)
    destroy_id_cache
    destroy_related_caches
  end
  def unlike
    ActiveRecord::Base.connection.execute(<<-ESQL)
      UPDATE events
      SET num_likes = num_likes - 1
      WHERE id = #{id}
      AND num_likes >= 1
    ESQL
    destroy_id_cache
    destroy_related_caches
  end

  def member?(user)
    !private? || EventSubscription.exists?(event: self, user: user)
  end

  def self.owned_or_subscribed_by(user)
    Event.where(
          "user_id = ? " +
          "OR EXISTS (SELECT 1 FROM event_subscriptions " +
          "WHERE event_subscriptions.user_id = ? " +
          "AND event_subscriptions.event_id = events.id)",
          user.id, user.id
          )
  end
end
