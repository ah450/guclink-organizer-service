class Api::SchedulesController < ApplicationController
  prepend_before_filter :authorize_student, only: [:create]
  prepend_before_filter :authorize, only: [:create]
  prepend_before_filter :authenticate, only: [:create]
  rescue_from GUCServerError, with: :guc_server_error
  around_filter :wrap_in_transaction, only: [:create]

  def create
    begin
      guc_username = params.require(:guc_username)
      guc_password = params.require(:guc_password)
      slots, student_data = ScheduleSlot.fetch_from_guc(guc_username,
                                                        guc_password)
      info = StudentFetchedInfo.from_schedule_data(student_data)
      info.user = @current_user
      info.save!
      slots.each(&:save!)
      render json: { slots: slots.as_json,
                     student_info: info.as_json
      }, status: :created
    rescue
      raise GUCServerError
    end
  end

  protected

  def resource_name
    'schedule_slot'
  end

  private

  def guc_server_error
    render json: { message: error_messages[:guc_error] },
           status: :unprocessable_entity
  end
end
