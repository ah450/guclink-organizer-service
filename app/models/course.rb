# == Schema Information
#
# Table name: courses
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_courses_on_name  (name)
#

class Course < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true

  def as_json(_options = {})
    super(methods: [:topic_id])
  end

  def topic_id
    name.gsub(/[^a-zA-Z0-9\-_.]/, '')
  end
end
