require 'rails_helper'

RSpec.describe StudentRegistration, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :schedule_slot }
  it { should belong_to :user }
  it { should belong_to :schedule_slot }
  subject { FactoryGirl.build(:student_registration) }
  it { should validate_uniqueness_of(:user_id).scoped_to(:schedule_slot_id) }

  context '.recreate' do
    let(:student) { FactoryGirl.create(:student) }
    let(:old) { FactoryGirl.create_list(:student_registration, 5, user: student) }
    let(:newslots) { FactoryGirl.create_list(:tutorial, 2) }
    it 'removes old registrations' do
      old
      newslots
      expect {
        registrations = StudentRegistration.recreate(newslots, student)
      }.to change(StudentRegistration, :count).by(newslots.size - old.size)
    end
  end
  context '.destroy_slot' do
    let(:slot) { FactoryGirl.create(:schedule_slot) }
    it 'destroys a schedule slot if no more students are registered' do
      register1 = FactoryGirl.create(:student_registration, schedule_slot: slot)
      register2 = FactoryGirl.create(:student_registration, schedule_slot: slot)
      register3 = FactoryGirl.create(:student_registration, schedule_slot: slot)
      expect {
        register1.destroy
        register2.destroy
      }.to change(ScheduleSlot, :count).by 0
      expect {
        register3.destroy
      }.to change(ScheduleSlot, :count).by(-1)
      expect(slot.persisted?).to be false
    end
  end

  context '.user_student' do
    it 'validates that user is a student' do
      expect(FactoryGirl.build(:student_registration, user: FactoryGirl.create(:teacher))).to_not be_valid
    end
  end
end


