class SendTopicNotificationsJob < ActiveJob::Base
  queue_as :organizer_notifications
  DOWNSTREAM_URL = 'https://gcm-http.googleapis.com/gcm/send'

  def perform(notifications)
    EventMachine.run do
      multi = EventMachine::MultiRequest.new
      notifications.each { |n| multi.add send_topic_notification(n) }
      multi.callback do
        EventMachine.stop
      end
    end
  end

  def send_topic_notification(notification)
    request_headers = {
      'Content-Type': 'application/json',
      'Authorization': "key=#{Rails.application.config.gcm_api_key}"
    }
    request_data = {
      to: "/topics/#{notification.topic}",
      content_available: true,
      data: notification.as_json
    }
    EventMachine::HttpRequest.new(DOWNSTREAM_URL,
      connect_timeout: 120).post header: request_data,
      body: request_data.to_json
  end

end
