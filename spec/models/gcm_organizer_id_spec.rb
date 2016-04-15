require 'rails_helper'

RSpec.describe GcmOrganizerId, type: :model do
  subject { FactoryGirl.build(:gcm_organizer_id) }
  it { should belong_to :user }
  it { should validate_presence_of :user }
  it { should validate_presence_of :gcm }
  it { should validate_uniqueness_of :user }
  it { should validate_uniqueness_of :gcm }
end
