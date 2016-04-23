# Removes slots that are orphaned
# As in those who have no students registered to
# This is typical on schedule updates
class PostScheduleCleanupJob < ActiveJob::Base
  queue_as :organizer_maintenence

  def perform(new_slots, user)
    StudentRegistration.recreate(new_slots, user)
    orphan_slots = ScheduleSlot.find_by_sql([
      "SELECT slots.* from schedule_slots AS slots INNER JOIN student_registrations AS regs on " +
      "slots.id = regs.schedule_slot_id " +
      "WHERE regs.user_id = ? " +
      "AND slots.id NOT IN (?)",
      user.id, new_slots.map(&:id)
      ])
    orphan_slots.each(&:destroy)
  end
end
