require 'rails_helper'

RSpec.describe EventInvitation, type: :model do
  it { should belong_to :event }
  it { should belong_to :user }
  it { should validate_presence_of :event }
  it { should validate_presence_of :user }
  subject { FactoryGirl.create(:event_invitation) }
  it { should validate_uniqueness_of(:event_id).scoped_to(:user_id)}

  it 'does not allow event owner to invite self' do
    event = FactoryGirl.create(:event)
    subject = FactoryGirl.build(:event_invitation, user: event.owner, event: event)
    expect(subject).to_not be_valid
  end

  it 'does not allow sending an invitation to a user who is alreadys subscribed' do
    sub = FactoryGirl.create(:event_subscription)
    subject = FactoryGirl.build(:event_invitation, user: sub.user, event: sub.event)
    expect(subject).to_not be_valid
  end
end
