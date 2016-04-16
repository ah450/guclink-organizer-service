# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :string           not null
#
# Indexes
#
#  index_courses_on_name      (name)
#  index_courses_on_topic_id  (topic_id)
#

class Course < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  before_save :gen_topic_id

  def gen_topic_id
    self.topic_id = name.gsub(/[^a-zA-Z0-9\-_.]/, '')
  end
end
