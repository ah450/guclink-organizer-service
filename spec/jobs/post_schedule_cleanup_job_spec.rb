require 'rails_helper'

RSpec.describe PostScheduleCleanupJob, type: :job do
  let(:user) { FactoryGirl.create(:student) }
  it 'Recreates student registration' do
    slots = FactoryGirl.create_list(:schedule_slot, 3)
    expect{
        PostScheduleCleanupJob.perform_now(slots, user)
      }.to change(StudentRegistration, :count).by(3).and change(ScheduleSlot, :count).by(0)
  end

  it 'removes orphaned slots' do
    old_slots = FactoryGirl.create_list(:student_registration, 2, user: user).map(&:schedule_slot)
    new_slots = FactoryGirl.create_list(:schedule_slot, 3)
    expect{
      PostScheduleCleanupJob.perform_now(new_slots, user)
    }.to change(StudentRegistration, :count).by(1).and change(ScheduleSlot, :count).by(-2)
    expect(StudentRegistration.count).to eql 3
    expect(ScheduleSlot.count).to eql 3
    expect(old_slots.reduce(false){|m, e| m && e.persisted?}).to be false
    expect(new_slots.reduce(true){|m, e| m && e.persisted?}).to be true
    expect(StudentRegistration.where(schedule_slot: new_slots, user: user).count).to eql 3
  end
end
