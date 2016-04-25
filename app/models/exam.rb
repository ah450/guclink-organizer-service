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
  EXAM_COURSE_NAME_REGEX = /[A-Z]+\d+/

  def self.fetch_from_guc(guc_username, guc_password, student)
    html = fetch_exams(guc_username, guc_password)
    html = parse_html(html)
    table = html.css('#Table1 tr td[align=center] #Table2')
    rows = table.css('tr')
    rows = rows[1..-1] # First row is for headers
    exams = rows.map { |r| process_exam_row r }
    exams.each { |e| e.user = student }
  end

  def self.process_exam_row(row)
    cells = row.xpath('td')
    exam = Exam.new
    course_name = cells[0].text.strip
    exam.course = find_course_by_exam_name(course_name)
    # Second cell is exam day name
    date = cells[2].text.strip
    start_time = cells[3].text.strip
    end_time = cells[4].text.strip
    exam.start_date = build_date(date, start_time)
    exam.end_date = build_date(date, end_time)
    exam.location = cells[5].text.strip
    exam.seat = cells[6].text.strip
    exam.exam_type = cells[7].text.strip
    return exam
  end

  def self.find_course_by_exam_name(name)
    match = EXAM_COURSE_NAME_REGEX.match name
    if match
      standarized_name = match[0].strip
      first_num_index = /\d/ =~ standarized_name
      standarized_name = "#{standarized_name[0...first_num_index]} #{standarized_name[first_num_index..-1]}"
      return Course.find_or_create_by(name: standarized_name)
    else
      return nil
    end
  end

  def self.build_date(date, time)
    DateTime.parse("#{date.gsub('-', '')} #{time} GMT+2").utc
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
