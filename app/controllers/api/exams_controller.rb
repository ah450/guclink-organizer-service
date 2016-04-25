class Api::ExamsController < ApplicationController
  prepend_before_filter :authorize_student
  prepend_before_filter :authorize
  prepend_before_filter :authenticate
  rescue_from GUCServerError, with: :guc_server_error
  around_filter :wrap_in_transaction, only: [:create]


  def create
    guc_username = params.require(:guc_username)
    guc_password = params.require(:guc_password)
    Exam.where(user: @current_user).delete_all
    @exams = Exam.fetch_from_guc(guc_username, guc_password, @current_user)
    @exams.each(&:save!)
    render json: { exams: @exams.as_json }, status: :created
  rescue
    raise GUCServerError
  end

  protected

  def base_index_query
    Exam.where(user: @current_user)
  end

  private

  def guc_server_error
    render json: { message: error_messages[:guc_error] },
           status: :unprocessable_entity
  end
end
