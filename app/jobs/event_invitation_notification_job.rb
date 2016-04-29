class EventInvitationNotificationJob < ActiveJob::Base
  queue_as :organizer_notifications

  def perform(invitation)
    # Do something later
  end
end
