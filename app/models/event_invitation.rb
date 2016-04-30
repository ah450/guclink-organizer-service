# == Schema Information
#
# Table name: event_invitations
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rejected   :boolean          default(FALSE), not null
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
  validates :event, :user, presence: true
  validates :event_id, uniqueness: {scope: :user_id}
  validates :rejected, inclusion: [true, false]
  validate :invited_not_owner
  validate :not_accepted
  after_commit :notify_invited, on: [:create]

  def accept!
    EventSubscription.from_invitation(self).save!
  end

  def reject!
    self.rejected = true
    save!
  end

  private

  def invited_not_owner
    if event.present? && user.present?
      errors.add(:user, 'must not be owner') if user == event.owner
    end
  end

  def not_accepted
    if event.present? && user.present?
      errors.add(:user, 'already accepted') if EventSubscription.exists?(event: event, user: user)
    end
  end

  def notify_invited
    EventInvitationNotificationJob.perform_later(self)
  end
  
end
