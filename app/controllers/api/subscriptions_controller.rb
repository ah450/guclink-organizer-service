class Api::SubscriptionsController < ApplicationController
  before_action :authenticate, :authorize
  before_action :subscriber_only, only: [:destroy]

  protected

  def subscriber_only
    raise ForbiddenError unless get_resource.user_id == @current_user.id
  end

  def base_index_query
    EventSubscription.where(user: @current_user)
  end

  def resource_name
    'event_subscription'
  end

end
