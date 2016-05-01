class EventInvitationNotificationJob < ActiveJob::Base
  queue_as :organizer_notifications

  def perform(invitation)
    Notification.create(
      sender: invitation.event.owner,
      receiver: invitation.user,
      data: {
        sub_type: 'event_invitation',
        invitation: invitation.as_json
      }
    )
  end
end
