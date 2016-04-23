require 'rails_helper'

RSpec.describe ScheduleSlot, type: :model do
  it { should belong_to :course }
  it { should validate_presence_of :course }
  it { should validate_presence_of :slot_num }
  it { should validate_presence_of :day }
  it { should validate_presence_of :name }
  it { should have_many :student_registrations }
  it { should have_many :students }

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
    it 'parses schedule correctly' do
      slots = ScheduleSlot.fetch_from_guc('', '').first
      saturday = slots.select { |e| e.day == 0  }
      sunday = slots.select { |e| e.day == 1  }
      monday = slots.select { |e| e.day == 2  }
      tuesday = slots.select { |e| e.day == 3  }
      wednesday = slots.select { |e| e.day == 4  }
      thursday = slots.select { |e| e.day == 5  }
      expect(saturday.size).to eql 1
      expect(sunday.size).to eql 4
      expect(monday.size).to eql 2
      expect(tuesday.size).to eql 4
      expect(wednesday.size).to eql 1
      expect(thursday.size).to eql 1
      math_lecture_sat = saturday.find do |slot|
        slot.lecture && slot.name == 'MATH 203' && slot.slot_num == 2
      end
      expect(math_lecture_sat.present?).to be true

      monday_math_second_tut = monday.find do |slot|
        slot.tutorial && slot.name == 'MATH 203' && slot.slot_num == 1
      end
      expect(monday_math_second_tut.present?).to be true
      tuesday_iot_lab = tuesday.find do |slot|
        slot.lab && slot.name == 'CSEN 1057' && slot.slot_num == 4
      end
      expect(tuesday_iot_lab.present?).to be true
    end
  end

end
