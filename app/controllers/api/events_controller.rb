class Api::EventsController < ApplicationController
  before_action :authenticate, :authorize
  before_action :member?, only: [:like, :unlike]
  before_action :owner_only, only: [:destroy]

  def like
    @event.like
    render json: @event
  end

  def unlike
    @event.unlike
    render json: @event
  end


  protected

  def member?
    raise ForbiddenError unless @event.member?(@current_user)
  end

  def owner_only
    raise ForbiddenError unless @event.user_id == @current_user.id
  end

  # Events that are public
  # Owned by the current user
  # Or subscribed to by the current user
  def base_index_query
    Event.find_by_sql([
      "SELECT * FROM events " +
      "WHERE user_id = ? " +
      "OR private = false " +
      "OR EXISTS (SELECT 1 FROM event_subscriptions " +
      "WHERE event_subscriptions.user_id = ? " +
      "AND event_subscriptions.event_id = events.id)",
      @current_user.id, @current_user.id
      ])
  end

  def event_params
    attributes = model_attributes
    attributes.delete :user_id
    attributes.delete :num_likes
    attributes.delete :id
    params.permit(attributes).merge({
      owner: @current_user
    })
  end

  def query_params
    params.permit(:created_at)
  end

  def apply_query(base, query_params)
    if query_params[:created_at].present?
      base.where("created_at >= ?", query_params[:created_at])
    else
      super
    end
  end

  def order_args
    {created_at: :desc}
  end
end
