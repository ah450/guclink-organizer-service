class Api::NotificationsController < ApplicationController
  before_action :authenticate, :authorize

  def create
    type = params.require(:type)
    if  type == 'topic_notification'
      create_topic_helper
    elsif type == 'user_notification'
      create_users_helper
    else
      raise ActionController::ParameterMissing.new("unknown notification type")
    end
  end

  # Retrieves all sent notifications
  def sent
    @notifications = Notification.where(sender: @current_user)
                                  .order({created_at: :desc})
                                  .page(page_params[:page])
                                  .per(page_params[:page_size])
    render_multiple
  end

  # Retrieves all received notifications
  def received
    @notifications = Notification.where('receiver_id = ? ' +
        'OR receiver_id IS NULL ' +
        'OR topic IN (?)',
        @current_user.id, @current_user.get_subscribed_topic_ids)
        .order({created_at: :desc})
        .page(page_params[:page])
        .per(page_params[:page_size])
    render_multiple
  end

  private

  def notification_params
    type = params.require(:type)
    if type == 'topic_notification'
      {
        sender: @current_user,
        topic: params.require(:topic),
        data: {
          subject: params.require(:subject),
          text: params.require(:text)
        }
      }
    elsif type == 'user_notification'
      {
        receivers: params.permit(receivers: []),
        sender: @current_user,
        data: {
          subject: params.require(:subject),
          text: params.require(:text)
        }
      }
    else
      raise ActionController::ParameterMissing.new("unknown notification type")
    end
  end

  def create_topic_helper
    @notification = TopicNotification.create(**notification_params)
    render json: @notification, status: :created
  end

  def create_users_helper
    params = notification_params
    Notification.transaction do
      receivers = params[:receivers].map { |r| User.find r }
      @notifications = receivers.map do |r|
        Notification.create(sender: params[:sender],
                            receiver: r,
                            data: params[:data]
        )
      end
    end
    render json: @notifications, status: :created
  end
end
