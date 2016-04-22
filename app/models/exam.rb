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
#
# Indexes
#
#  index_exams_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_66aea76c6a  (course_id => courses.id)
#

class Exam < ActiveRecord::Base
  belongs_to :course
end
