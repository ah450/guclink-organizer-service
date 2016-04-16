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
      slots = ScheduleSlot.fetch_from_guc('', '')
      expect(slots.reduce(true) { |m, e| m && e.valid? }).to be true
    end
  end
end
