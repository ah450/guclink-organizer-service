# == Schema Information
#
# Table name: exams
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  start_date :datetime         not null
#  end_date   :datetime         not null
#  location   :string           not null
#  seat       :string           not null
#  exam_type  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_exams_on_course_id  (course_id)
#  index_exams_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_1ef6db8efd  (user_id => users.id)
#  fk_rails_66aea76c6a  (course_id => courses.id)
#

class Exam < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  validates :course, :start_date, :end_date, :location, :seat, :exam_type,
    :user, presence: true

  def self.fetch_from_guc(guc_username, guc_password)
    html = fetch_exams(guc_username, guc_password)
    html = parse_html(html)
  end

  def self.parse_html(html)
    Nokogiri::HTML(html)
  end

  def self.fetch_exams(guc_username, guc_password)
    url = "http://#{guc_username.strip}:#{guc_password.strip}@student.guc.edu.eg/External/Student/ViewStudentSeat/ViewExamSeat.aspx"
    io = IO.popen "curl -s --ntlm #{url}"
    lines = io.readlines
    io.close
    raise GUCServerError unless $?.exitstatus == 0
    lines.join '\n'
  end

end
