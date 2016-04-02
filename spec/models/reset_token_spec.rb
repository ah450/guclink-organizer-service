# == Schema Information
#
# Table name: reset_tokens
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ResetToken, type: :model do
  let(:subject) { FactoryGirl.create(:reset_token) }
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should validate_presence_of :token }
  it { should validate_uniqueness_of :user }

  it 'has a valid factory' do
    token = FactoryGirl.build(:reset_token)
    expect(token).to be_valid
  end
  it 'requires token' do
    token = FactoryGirl.build(:reset_token, token: nil)
    expect(token).to_not be_valid
  end
  it 'requires user' do
    token = FactoryGirl.build(:reset_token, user: nil)
    expect(token).to_not be_valid
  end
end
