class EventInvitationNotificationJob < ActiveJob::Base
  queue_as :organizer_notifications

  def perform(invitation)
  end
end
