require 'rails_helper'

RSpec.describe Exam, type: :model do
  it { should validate_presence_of :course }
  it { should validate_presence_of :user }
  it { should validate_presence_of :course }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :location }
  it { should validate_presence_of :seat }
  it { should validate_presence_of :exam_type }
  it { should belong_to :course }
  it { should belong_to :user }

  context '.fetch_from_guc' do
    class Exam
      def self.parse_html(_html)
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'exams/ViewExamSeat.html')
        Nokogiri::HTML(open(path))
      end
    end
    let(:student) { FactoryGirl.create(:student) }

    it 'returns valid exams' do
      exams = Exam.fetch_from_guc('', '', student)
      expect(exams.reduce(true) { |m, e| m && e.valid? }).to be true
    end

    it 'parses schedule correctly' do
      exams = Exam.fetch_from_guc('', '', student)
      expect(exams.size).to eql 8
      expect(exams[0].course.name).to eql 'HUMA 1001'
      expect(exams[0].location).to eql 'C7.02'
      expect(exams[1].course.name).to eql 'CSEN 1057'
      expect(exams[1].seat).to eql 'A1'
    end

  end

  context '.build_date' do
    let(:date){ '7 - March - 2016' }
    let(:time){ '10:30:00 AM' }
    let(:expected) { DateTime.new 2016, 3, 7, 8, 30 }
    it 'parses dates correctly' do
      expect(Exam.build_date(date, time)).to eql expected
    end
  end

  context '.find_course_by_exam_name' do
    let(:name){ 'MET Computer Science 10th Semester - CSEN1057 The Semantic IoT - Spring 2016' }
    let(:course) { FactoryGirl.create(:course, name: 'CSEN 1057') }
    it 'finds correct course' do
      FactoryGirl.create(:course, name: 'CSEN 1058')
      FactoryGirl.create(:course, name: 'CSEN 57')
      FactoryGirl.create(:course, name: 'CSEN 1059')
      FactoryGirl.create(:course, name: 'CSEN 1060')
      FactoryGirl.create(:course, name: 'DMET 1049')
      FactoryGirl.create(:course, name: 'DMET 1057')
      course
      expect {
        expect(Exam.find_course_by_exam_name(name)).to eql course
      }.to change(Course, :count).by 0
    end
  end
end
