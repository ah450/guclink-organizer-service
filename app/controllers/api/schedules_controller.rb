class Api::SchedulesController < ApplicationController
  prepend_before_filter :authenticate, :authorize, :authorize_student,
                        only: [:create]
  rescue_from GUCServerError, with: :guc_server_error
  around_filter :wrap_in_transaction, only: [:create]
  def create
    begin
      guc_username = params.require(:guc_username)
      guc_password = params.require(:guc_password)
      slots, student_data = ScheduleSlot.fetch_from_guc(guc_username,
                                                        guc_password)
      StudentFetchedInfo.from_schedule_data(student_data).save!
      slots.each(:save!)
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
  end
end
