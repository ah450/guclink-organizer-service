require 'rails_helper'

RSpec.describe ScheduleSlot, type: :model do
  it { should belong_to :course }
  it { should validate_presence_of :course }
  it { should validate_presence_of :slot_num }
  it { should validate_presence_of :day }

  context '.fetch_from_guc' do
    class ScheduleSlot
      def self.parse_html(_html)
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'schedules/ahi.html')
        Nokogiri::HTML(open(path))
      end
    end
    it 'returns valid slots' do
      slots = ScheduleSlot.fetch_from_guc('', '').first
      expect(slots.reduce(true) { |m, e| m && e.valid? }).to be true
    end

    it 'parses student data correctly' do
      _, student_data = ScheduleSlot.fetch_from_guc('', '')
      expect(student_data[:name]).to match 'Ahmed Hisham Nasreldin Ismail'
      expect(student_data[:guc_id]).to match '16-4477'
    end
  end
end
