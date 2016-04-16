# == Schema Information
#
# Table name: student_fetched_infos
#
#  id            :integer          not null, primary key
#  guc_id_prefix :integer          not null
#  guc_id_suffix :integer          not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_student_fetched_infos_on_guc_id_prefix_and_guc_id_suffix  (guc_id_prefix,guc_id_suffix)
#

class StudentFetchedInfo < ActiveRecord::Base
  validates :guc_id_suffix, :guc_id_prefix, :name, presence: true

  def guc_id
    "#{guc_prefix}-#{guc_suffix}"
  end

  def guc_id=(value)
    guc_prefix, guc_suffix = value.split '-'
    self.guc_id_prefix = guc_prefix.to_i
    self.guc_id_suffix = guc_suffix.to_i
  end

  def self.from_schedule_data(data)
    StudentFetchedInfo.new name: data[:name], guc_id: data[:guc_id]
  end
end
