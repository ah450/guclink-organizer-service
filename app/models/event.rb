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
#
# Indexes
#
#  index_events_on_created_at  (created_at)
#

class Event < ActiveRecord::Base
end
