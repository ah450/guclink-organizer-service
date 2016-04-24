class Api::SchedulesController < ApplicationController
  prepend_before_filter :authorize_student, only: [:create]
  prepend_before_filter :authorize, only: [:create]
  prepend_before_filter :authenticate, only: [:create]
  rescue_from GUCServerError, with: :guc_server_error
  around_filter :wrap_in_transaction, only: [:create]
  after_filter :perform_cleanup, only: [:create]

  def create
    guc_username = params.require(:guc_username)
    guc_password = params.require(:guc_password)
    @slots, student_data = ScheduleSlot.fetch_from_guc(guc_username,
                                                      guc_password)
    StudentFetchedInfo.where(user: @current_user).delete_all
    info = StudentFetchedInfo.from_schedule_data(student_data)
    info.user = @current_user
    info.save!
    @slots.map!(&:save_or_fetch)
    @slots.select! { |s| s.present? }
    render json: { slots: @slots.as_json,
                   student_info: info.as_json
    }, status: :created
  rescue
    raise GUCServerError
  end

  protected

  def resource_name
    'schedule_slot'
  end

  private

  def perform_cleanup
    PostScheduleCleanupJob.perform_later(@slots, @current_user)
  rescue
  end

  def guc_server_error
    render json: { message: error_messages[:guc_error] },
           status: :unprocessable_entity
  end
end
