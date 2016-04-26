require 'rails_helper'

RSpec.describe EventInvitation, type: :model do
  it { should belong_to :event }
  it { should belong_to :user }
  it { should validate_presence_of :event }
  it { should validate_presence_of :user }
  subject { FactoryGirl.create(:event_invitation) }
  it { should validate_uniqueness_of(:event_id).scoped_to(:user_id)}
end
