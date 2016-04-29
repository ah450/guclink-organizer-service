require 'rails_helper'

RSpec.describe Api::SubscriptionsController, type: :controller do
  context 'index' do

    let(:event) { FactoryGirl.create(:event) }
    let(:subscriber) { FactoryGirl.create(:student) }
    let(:subscriptions) { FactoryGirl.create_list(:event_subscription, 3, user: subscriber) }
    it 'does not allow unauthorized' do
      get :index
      expect(response).to be_unauthorized
    end

    it 'lists my subscriptions only' do
      subscriptions
      set_token subscriber.token
      FactoryGirl.create_list(:event_subscription, 4, event: event)
      get :index, page_size: 200
      expect(response).to be_success
      expect(json_response[:event_subscriptions].map { |e| e[:id] }).to contain_exactly(*subscriptions.map(&:id))
    end

  end
  context 'destroy' do
    let(:subscription) { FactoryGirl.create(:event_subscription) }
    let(:subscriber) { subscription.user }
    let(:event_owner) { subscription.event.owner }
    let(:random) { FactoryGirl.create(:student) }
    it 'does not allow unauthorized' do
      delete :destroy, id: subscription.id
      expect(response).to be_unauthorized
    end

    it 'does not allow random' do
      set_token random.token
      delete :destroy, id: subscription.id
      expect(response).to be_forbidden
    end

    it 'does not allow event owner' do
      set_token event_owner.token
      delete :destroy, id: subscription.id
      expect(response).to be_forbidden
    end

    it 'allows subcriber' do
      set_token subscriber.token
      expect{
        delete :destroy, id: subscription.id
        expect(response).to be_success
      }.to change(EventSubscription, :count).by(-1)
    end
  end
end
