require 'rails_helper'

RSpec.describe StudentFetchedInfo, type: :model do
  it { should validate_presence_of :guc_id_suffix }
  it { should validate_presence_of :guc_id_prefix }
  it { should validate_presence_of :name }
  it { should validate_presence_of :user }
  it { should belong_to :user }
  subject { FactoryGirl.build(:student_fetched_info) }
  it { should validate_uniqueness_of :user }

  context 'guc_id=' do
    it 'parses correctly' do
      info = StudentFetchedInfo.new name: 'haha man', guc_id: '  33 -  222'
      expect(info.guc_id_prefix).to eql 33
      expect(info.guc_id_suffix).to eql 222
    end
  end
end
