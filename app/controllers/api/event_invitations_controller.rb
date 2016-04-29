class Api::EventInvitationsController < ApplicationController
  before_action :authenticate, :authorize
  before_action :owner_only, only: [:destroy, :create]
  before_action :not_rejected, only: [:destroy]
  before_action :not_accepted, only: [:destroy]
  before_action :invited_only, only: [:accept, :reject]
  before_action :related_only, only: [:show]
  around_action :wrap_in_transaction, only: [:accept, :reject]


  def accept
    sub = @event_invitation.accept!
    @event_invitation.destroy
    render json: sub
  end

  def reject
    @event_invitation.reject!
    render json: @event_invitation
  end


  protected


  def query_params
    if params[:outgoing] == 'true'
      { events: { user_id: @current_user.id } }
    elsif params[:outgoing] == 'false'
      { event_invitations: { user_id: @current_user.id } }
    else
      {}
    end
  end


  def base_index_query
    EventInvitation.joins(:event).where(
      "events.user_id = ? " +
      "OR event_invitations.user_id = ? ",
      @current_user.id, @current_user.id
      )
  end

  def related_only
    unless get_resource.user == @current_user || get_resource.event.owner == @current_user
      raise ForbiddenError
    end
  end

  def invited_only
    raise ForbiddenError unless EventInvitation.exists?(user: @current_user, event: get_event)
  end

  def not_rejected
    # Trigger bad request response
    raise ActionController::ParameterMissing.new("already rejected") if @event_invitation.rejected?
  end

  def not_accepted
    # Trigger bad request response
    raise ActionController::ParameterMissing.new("already accepted") if EventSubscription.exists?(event: @event_invitation.event, user: @event_invitation.user)
  end


  def owner_only
    raise ForbiddenError unless get_event.user_id == @current_user.id
  end


  def get_event
    if params.has_key?(:id)
      @event ||= get_resource.event
    else
      @event ||= Event.find params.require(:event_id)
    end
  end

  def event_invitation_params
    {
      event: get_event,
      user: User.find(params.require(:user_id))
    }
  end

  def order_args
    {created_at: :desc}
  end
end
