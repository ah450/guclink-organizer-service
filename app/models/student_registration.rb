# == Schema Information
#
# Table name: student_registrations
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  schedule_slot_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_student_registrations_on_schedule_slot_id  (schedule_slot_id)
#  index_student_registrations_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_3eb89e849b  (user_id => users.id)
#  fk_rails_62c06b4928  (schedule_slot_id => schedule_slots.id)
#

class StudentRegistration < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule_slot
  validate :user_student
  validates :user, :schedule_slot, presence: true
  validates :user_id, uniqueness: { scope: :schedule_slot_id }
  after_destroy :destroy_slot

  def self.recreate(slots, user)
    StudentRegistration.where(user: user).destroy_all
    slots.map { |s| StudentRegistration.create(schedule_slot: s, user: user) }
  end

  def user_student
    errors.add(:user, 'must be student') unless user.present? && user.student?
  end

  private
  
  # Destroy slot if no more registrations
  def destroy_slot
    if schedule_slot.present? && schedule_slot.student_registrations.count == 0
      schedule_slot.destroy
    end
  end
end
