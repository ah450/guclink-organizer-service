class SendUsersNotificationJob < ActiveJob::Base
  queue_as :organizer_notifications
  DOWNSTREAM_URL = 'https://gcm-http.googleapis.com/gcm/send'

  def perform(users, notification)
    ids = users.map(&:gcm_organizer_id).map(&:gcm)
    EventMachine.run do
      multi = EventMachine::MultiRequest.new
      ids.each { |id| multi.add send_notification(id, notification) }
      multi.callback do
        EventMachine.stop
      end
    end
  end

  def send_notification(id, notification)
    request_headers = {
      'Content-Type': 'application/json',
      'Authorization': "key=#{Rails.application.config.gcm_api_key}"
    }
    request_data = {
      to: id,
      content_available: true,
      data: notification.as_json
    }
    EventMachine::HttpRequest.new(DOWNSTREAM_URL,
      connect_timeout: 120).post header: request_data,
      body: request_data.to_json
  end
end
