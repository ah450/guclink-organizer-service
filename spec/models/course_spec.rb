require 'rails_helper'

RSpec.describe Course, type: :model do
 subject { FactoryGirl.build(:course) }
 it { should validate_presence_of :name }
 it { should validate_uniqueness_of :name }
end
