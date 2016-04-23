# Removes slots that are orphaned
# As in those who have no students registered to
# This is typical on schedule updates
class PostScheduleCleanupJob < ActiveJob::Base
  queue_as :organizer_maintenence

  def perform(new_slots, user)
    StudentRegistration.recreate(new_slots, user)
    orphan_slots = ScheduleSlot.find_by_sql([
      "SELECT slots.* FROM schedule_slots AS slots INNER JOIN student_registrations AS regs ON " +
      "slots.id = regs.schedule_slot_id " +
      "WHERE regs.user_id = ? " +
      "AND slots.id NOT IN (?)",
      user.id, new_slots.map(&:id)
      ])
    orphan_slots.each(&:destroy)
    ScheduleSlot.find_by_sql([
      "SELECT schedule_slots.* FROM schedule_slots " +
      "WHERE NOT EXISTS (SELECT 1 FROM student_registrations WHERE student_registrations.schedule_slot_id = schedule_slots.id)"
      ]).each(&:destroy)
  end
end
