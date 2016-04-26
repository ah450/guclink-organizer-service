require 'rails_helper'

RSpec.describe Api::EventsController, type: :controller do
  context 'index' do
    let(:owner) { FactoryGirl.create(:teacher) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:subscribed) { FactoryGirl.create(:student) }
    let(:neutral) { FactoryGirl.create(:student) }
    let(:events) { FactoryGirl.create_list(:event, 4, owner: owner) }
    let(:invitations) do
      events.each { |e| FactoryGirl.create(:event_invitation, event: e, user: invited) }
    end
    let(:subscriptions) do
      events.each { |e| FactoryGirl.create(:event_subscription, event: e, user: subscribed) }
    end
    it 'does not allow unauthorized' do
      invitations
      subscriptions
      get :index, format: :json
      expect(response).to be_unauthorized
    end
  end
  context 'create' do
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:event_params) { FactoryGirl.attributes_for(:event, user: nil)}
    it 'does not allow unauthorized' do
      post :create, format: :json, **event_params
      expect(response).to be_unauthorized
    end
    it 'allows student' do
      set_token student.token
      expect{
        post :create, format: :json, **event_params
        expect(response).to be_created
        expect(json_response[:user_id]).to eql student.id
      }.to change(Event, :count).by(1)
    end
    it 'allows teacher' do
      set_token teacher.token
      expect{
        post :create, format: :json, **event_params
        expect(response).to be_created
        expect(json_response[:user_id]).to eql teacher.id
      }.to change(Event, :count).by(1)
    end
  end
  context 'like' do
    let(:event) { FactoryGirl.create(:event, private: true) }
    let(:token) { event.user.token }
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:invited) { FactoryGirl.create(:event_invitation, event: event).user }
    let(:subscribed) { FactoryGirl.create(:event_subscription, event: event).user }
    it 'does not allow unauthorized' do
      put :like, id: event.id
      expect(response).to be_unauthorized
    end

    it 'does not allow unrelated teacher' do
      set_token teacher.token
      put :like, id: event.id
      expect(response).to be_forbidden
      event.reload
      expect(event.num_likes).to eql 0
    end

    it 'does not allow unrelated student' do
      set_token student.token
      put :like, id: event.id
      expect(response).to be_forbidden
      event.reload
      expect(event.num_likes).to eql 0
    end

    it 'does not allow invited user' do
      set_token invited.token
      put :like, id: event.id
      expect(response).to be_forbidden
      event.reload
      expect(event.num_likes).to eql 0
    end

    it 'allows subscribed users' do
      set_token subscribed.token
      put :like, id: event.id
      expect(response).to be_success
      event.reload
      expect(event.num_likes).to eql 1
    end

  end
  context 'unlike' do
    let(:event) { FactoryGirl.create(:event, private: true, num_likes: 1) }
    let(:token) { event.user.token }
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:invited) { FactoryGirl.create(:event_invitation, event: event).user }
    let(:subscribed) { FactoryGirl.create(:event_subscription, event: event).user }
    
    it 'does not allow unauthorized' do
      put :unlike, id: event.id
      expect(response).to be_unauthorized
      event.reload
      expect(event.num_likes).to eql 1
    end

    it 'does not allow unrelated teacher' do
      set_token teacher.token
      put :unlike, id: event.id
      expect(response).to be_forbidden
      event.reload
      expect(event.num_likes).to eql 1
    end

    it 'does not allow unrelated student' do
      set_token student.token
      put :unlike, id: event.id
      expect(response).to be_forbidden
      expect(event.num_likes).to eql 1
    end

    it 'does not allow invited user' do
      set_token invited.token
      put :unlike, id: event.id
      expect(response).to be_forbidden
      event.reload
      expect(event.num_likes).to eql 1
    end

    it 'allows subscribed users' do
      set_token subscribed.token
      put :unlike, id: event.id
      expect(response).to be_success
      event.reload
      expect(event.num_likes).to eql 0
    end

  end

  context 'destroy' do
    let(:event) { FactoryGirl.create(:event) }
    let(:token) { event.user.token }
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:invited) { FactoryGirl.create(:event_invitation, event: event).user }
    let(:subscribed) { FactoryGirl.create(:event_subscription, event: event).user }
    it 'does not allow unauthorized' do
      event
      expect{
        delete :destroy, id: event.id
        expect(response).to be_unauthorized
      }.to change(Event, :count).by(0)
    end

    it 'does not allow random student' do
      event
      set_token student.token
      expect{
        delete :destroy, id: event.id
        expect(response).to be_forbidden
      }.to change(Event, :count).by(0)
    end

    it 'does not allow random teacher' do
      event
      set_token teacher.token
      expect{
        delete :destroy, id: event.id
        expect(response).to be_forbidden
      }.to change(Event, :count).by(0)
    end

    it 'does not allow invited user' do
      event
      set_token invited.token
      expect{
        delete :destroy, id: event.id
        expect(response).to be_forbidden
      }.to change(Event, :count).by(0)
    end

    it 'does not allow subscribed user' do
      event
      set_token subscribed.token
      expect{
        delete :destroy, id: event.id
        expect(response).to be_forbidden
      }.to change(Event, :count).by(0)
    end

    it 'allows owner' do
      event
      set_token event.owner.token
      expect{
        delete :destroy, id: event.id
        expect(response).to be_success
      }.to change(Event, :count).by(-1)
    end

  end
end
