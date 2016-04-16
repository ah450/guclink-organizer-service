# == Schema Information
#
# Table name: schedule_slots
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  location   :string
#  group      :string
#  name       :string           not null
#  day        :integer          not null
#  slot_num   :integer          not null
#  tutorial   :boolean          not null
#  lecture    :boolean          not null
#  lab        :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_schedule_slots_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_25ea8d0fa8  (course_id => courses.id)
#

class ScheduleSlot < ActiveRecord::Base
  belongs_to :course
  validates :slot_num, :day, :course, :name, presence: true
  validates :tutorial, :lecture, :lab, inclusion: [true, false]

  def as_json(_options={})
    super(methods: [:topic_id, :group_topic_id]).merge({
      course: course.as_json })
  end

  def group_topic_id
    "#{name}-#{group}".gsub(/[^a-zA-Z0-9\-_.]/, '')
  end

  def topic_id
    topic = group_topic_id
    topic += '-lab' if lab?
    topic += '-tut' if tutorial?
    topic += '-lecture' if lecture?
    topic.gsub(/[^a-zA-Z0-9\-_.]/, '')
  end

  def self.fetch_from_guc(guc_username, guc_password)
    html = fetch_schedule(guc_username, guc_password)
    html = parse_html(html)
    table = html.css('#scdTbl')
    rows = table.xpath('tr')
    rows = rows[1..8] # First row is for headers
    current_day = 0
    slots = []
    rows.each do |row|
      slots.concat process_schedule_day(row, current_day)
      current_day += 1
    end
    student_info = html.css('#scdTpLbl font').text.strip
    data = student_info.split(' ', 2)
    guc_id = data[0].strip
    if data.size > 1
      student_name = data[1].gsub(/[^a-zA-Z0-9 ]/, '').strip
    end
    student_data = {
      name: student_name,
      guc_id: guc_id
    }
    return [slots, student_data]
  end

  def self.process_schedule_day(row, current_day)
    cells = row.xpath('td')
    # First cell is day name
    cells = cells[1..-1]
    slots = []
    cells.each_with_index do |cell, index|
      slot = process_schedule_cell(cell, current_day)
      slot.slot_num = index if slot.present?
      slots.push slot if slot.present?
    end
    return slots
  end

  def self.process_schedule_cell(cell, current_day)
    return process_lecture_or_free(cell, current_day) unless
      cell.css('span').empty?
    process_tutorial_or_lab(cell, current_day)
  end

  def self.process_lecture_or_free(cell, current_day)
    text = cell.css('span').first.text.strip
    return nil if /free/i === text
    slot = ScheduleSlot.new(day: current_day, lecture: true, lab: false,
                            tutorial: false)
    around_lecture = text.split(/lecture/i, 2)
    slot.name = around_lecture.first.strip
    # Create or find course
    slot.course = Course.find_or_create_by(name: slot.name)
    if around_lecture.size > 1
      group_location = around_lecture.second
      if group_location.include? ')'
        around_bracket = group_location.split ')'
        slot.group = around_bracket.first.strip[1..-1]
        slot.location = around_bracket.second.strip if around_bracket.size > 1
      end
    end
    return slot
  end

  def self.process_tutorial_or_lab(cell, current_day)
    fonts = cell.css('font')
    return nil unless fonts.size >= 3
    slot = ScheduleSlot.new(day: current_day, lecture: false, lab: false,
                            tutorial: false)
    slot.group = fonts[0].text.strip
    slot.location = fonts[1].text.strip
    slot.name = fonts[2].text.strip
    slot.tutorial = slot.name.end_with?('Tut').to_s
    slot.lab = slot.name.end_with?('Lab').to_s
    slot.name = slot.name.gsub(/Lab|Tut/, '').strip
    slot.course = Course.find_or_create_by(name: slot.name)
    return slot
  end

  def self.parse_html(html)
    Nokogiri::HTML(html)
  end

  def self.fetch_schedule(guc_username, guc_password)
    url = "http://#{guc_username.strip}:#{guc_password.strip}@student.guc.edu.eg/Web/Student/Schedule/GroupSchedule.aspx"
    io = IO.popen "curl -s --ntlm #{url}"
    lines = io.readlines
    io.close
    raise GUCServerError unless $?.exitstatus == 0
    lines.join '\n'
  end
end
