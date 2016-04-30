class Api::CoursesController < ApplicationController
  before_action :authenticate, :authorize
  before_action :can_view, only: [:show]

  protected

  def base_index_query
    if @current_user.student?
      Course.joins(schedule_slots: :student_registrations).where(
        student_registrations: { user_id: @current_user.id})
    else
      super
    end
  end

  def can_view
    if @current_user.student? && Course.joins(schedule_slots: :student_registrations).where(
        student_registrations: { user_id: @current_user.id}).where(id: params.require(:id)).count == 0
      raise ForbiddenError
    end
  end

  def order_args
    :name
  end

end
