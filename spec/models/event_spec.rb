require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :owner }
  it { should belong_to :owner }
  it { should have_many :event_invitations }
  it { should have_many :event_subscriptions }
  let(:event) { FactoryGirl.create(:event) }


  context '.like' do
    it 'increments likes' do
      expect(event.num_likes).to eql 0
      event.like
      event.reload
      expect(event.num_likes).to eql 1
    end
  end

  context '.unlike' do
    it 'decrements likes' do
      event.num_likes = 1
      event.save!
      expect(event.num_likes).to eql 1
      event.unlike
      event.reload
      expect(event.num_likes).to eql 0
    end
    it 'does not go below 0' do
      expect(event.num_likes).to eql 0
      event.unlike
      event.reload
      expect(event.num_likes).to eql 0
    end
  end

end
