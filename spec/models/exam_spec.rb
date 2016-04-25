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
end
