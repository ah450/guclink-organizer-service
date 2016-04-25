# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :string           not null
#  start_date  :datetime         not null
#  end_date    :datetime         not null
#  num_likes   :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  private     :boolean          default(FALSE), not null
#
# Indexes
#
#  index_events_on_created_at  (created_at)
#

class Event < ActiveRecord::Base
  validates :title, :description, :start_date, :end_date, presence: true
  validates :private, inclusion: [true, false]

  def like
    Event.increment_counter(:num_likes, id)
  end
  def unlike
    ActiveRecord::Base.connection.execute(<<-ESQL)
      UPDATE events
      SET num_likes = num_likes - 1
      WHERE id = #{id}
      AND num_likes >= 1
    ESQL
  end
end
