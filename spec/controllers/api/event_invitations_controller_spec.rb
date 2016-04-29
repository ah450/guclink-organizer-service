require 'rails_helper'

RSpec.describe Api::EventInvitationsController, type: :controller do
  context 'create' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:event) { FactoryGirl.create(:event, owner: owner) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:invitation_params) do
      {
        user_id: invited.id,
        event_id: event.id
      }
    end
    let(:random) { FactoryGirl.create(:teacher) }
    
    it 'does not allow unauthorized' do
      expect{
        post :create, **invitation_params
        expect(response).to be_unauthorized
      }.to  change(EventInvitation, :count).by(0)
    end
    
    it 'does not allow user other than owner' do
      expect{
        set_token random.token
        post :create, **invitation_params
        expect(response).to be_forbidden
      }.to  change(EventInvitation, :count).by(0)
    end
    
    it 'allows owner' do
      expect{
        set_token owner.token
        post :create, **invitation_params
        expect(response).to be_created
      }.to  change(EventInvitation, :count).by(1)
    end
    
    it 'sends invited notification' do
      expect(EventInvitationNotificationJob).to receive(:perform_later).once
      set_token owner.token
      post :create, **invitation_params
    end
  end
  
  context 'index' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:events) { FactoryGirl.create_list(:event, 4, owner: owner) }
    let(:invited_one) { FactoryGirl.create(:student) }
    let(:invited_two) { FactoryGirl.create(:teacher) }
    let(:random) { FactoryGirl.create(:teacher) }
    let(:incoming_invitations) { FactoryGirl.create_list(:event_invitation, 2, user: owner) }
    let(:invitations_one) do
      events.map { |e| FactoryGirl.create(:event_invitation, event: e, user: invited_one) }
    end
    let(:invitations_two) do
      events.map { |e| FactoryGirl.create(:event_invitation, event: e, user: invited_two) }
    end

    it 'does not allow unauthorized' do
      get :index
      expect(response).to be_unauthorized
    end

    it 'shows nothing for unrelated' do
      invitations_one
      invitations_two
      set_token random.token
      get :index
      expect(json_response[:event_invitations].size).to eql 0
    end

    it 'shows my invitations' do
      invitations_one
      invitations_two
      incoming_invitations
      set_token invited_one.token
      get :index
      expect(response).to be_success
      received_ids = json_response[:event_invitations].map { |e| e[:id]  }
      expected_ids = invitations_one.map(&:id)
      expect(received_ids).to contain_exactly(*expected_ids)
    end

    it 'shows my invitations' do
      invitations_one
      invitations_two
      incoming_invitations
      set_token invited_two.token
      get :index
      received_ids = json_response[:event_invitations].map { |e| e[:id]  }
      expected_ids = invitations_two.map(&:id)
      expect(received_ids).to contain_exactly(*expected_ids)
    end

    it 'shows my incoming and outgoing invitations' do
      invitations_one
      invitations_two
      incoming_invitations
      set_token owner.token
      get :index, page_size: 200
      received_ids = json_response[:event_invitations].map { |e| e[:id]  }
      expected_ids = invitations_one.map(&:id) + invitations_two.map(&:id) + incoming_invitations.map(&:id)
      expect(received_ids).to contain_exactly(*expected_ids)
    end

    it 'can filter to outgoing invitations only' do
      invitations_one
      invitations_two
      incoming_invitations
      set_token owner.token
      get :index, page_size: 200, outgoing: 'true'
      received_ids = json_response[:event_invitations].map { |e| e[:id]  }
      expected_ids = invitations_one.map(&:id) + invitations_two.map(&:id)
      expect(received_ids).to contain_exactly(*expected_ids)
    end
    
    it 'can filter to incoming invitations only' do
      invitations_one
      invitations_two
      incoming_invitations
      set_token owner.token
      get :index, page_size: 200, outgoing: 'false'
      received_ids = json_response[:event_invitations].map { |e| e[:id]  }
      expected_ids = incoming_invitations.map(&:id)
      expect(received_ids).to contain_exactly(*expected_ids)
    end

  end
  
  context 'destroy' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:event) { FactoryGirl.create(:event, owner: owner) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:invitation){ FactoryGirl.create(:event_invitation, event: event, user: invited) }
    let(:random) { FactoryGirl.create(:teacher) }
    
    it 'does not allow unauthorized' do
      invitation
      expect {
        delete :destroy, id: invitation.id
        expect(response).to be_unauthorized
      }.to change(EventInvitation, :count).by(0)
    end
    
    it 'does not allow invited' do
      invitation
      expect {
        set_token invited.token
        delete :destroy, id: invitation.id
        expect(response).to be_forbidden
      }.to change(EventInvitation, :count).by(0)
    end
    
    it 'does not allow random user' do
      invitation
      expect {
        set_token random.token
        delete :destroy, id: invitation.id
        expect(response).to be_forbidden
      }.to change(EventInvitation, :count).by(0)
    end
    
    it 'allows inviter' do
      invitation
      expect {
        set_token owner.token
        delete :destroy, id: invitation.id
        expect(response).to be_success
      }.to change(EventInvitation, :count).by(-1)
    end

    it 'does not allow destruction of accepted' do
      invitation.accept!
      expect {
        set_token owner.token
        delete :destroy, id: invitation.id
        expect(response).to be_bad_request
      }.to change(EventInvitation, :count).by(0)
    end

    it 'does not allow destruction of rejected' do
      invitation.reject!
      expect {
        set_token owner.token
        delete :destroy, id: invitation.id
        expect(response).to be_bad_request
      }.to change(EventInvitation, :count).by(0)
    end
  end
  
  context 'show' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:event) { FactoryGirl.create(:event, owner: owner) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:invitation){ FactoryGirl.create(:event_invitation, event: event, user: invited) }
    let(:random) { FactoryGirl.create(:teacher) }
    
    it 'does not allow unauthorized' do
      get :show, id: invitation.id
      expect(response).to be_unauthorized
    end
    
    it 'does not allow random' do
      set_token random.token
      get :show, id: invitation.id
      expect(response).to be_forbidden
    end
    
    it 'allows owner' do
      set_token owner.token
      get :show, id: invitation.id
      expect(response).to be_success
    end
    
    it 'allows invited' do
      set_token invited.token
      get :show, id: invitation.id
      expect(response).to be_success
    end
  end
  
  context 'accept' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:event) { FactoryGirl.create(:event, owner: owner) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:invitation){ FactoryGirl.create(:event_invitation, event: event, user: invited) }
    let(:random) { FactoryGirl.create(:teacher) }
    
    it 'does not allow unauthorized' do
      put :accept, id: invitation.id
      expect(response).to be_unauthorized
    end
    
    it 'does not allow random' do
      set_token random.token
      put :accept, id: invitation.id
      expect(response).to be_forbidden
    end

    it 'does not allow owner' do
      set_token owner.token
      put :accept, id: invitation.id
      expect(response).to be_forbidden
    end

    it 'allows invited' do
      invitation
      set_token invited.token
      expect{
        put :accept, id: invitation.id
        expect(response).to be_success
      }.to change(EventInvitation, :count).by(-1).and change(EventSubscription, :count).by(1)
    end

  end
  
  context 'reject' do
    let(:owner) { FactoryGirl.create(:student) }
    let(:event) { FactoryGirl.create(:event, owner: owner) }
    let(:invited) { FactoryGirl.create(:student) }
    let(:invitation){ FactoryGirl.create(:event_invitation, event: event, user: invited) }
    let(:random) { FactoryGirl.create(:teacher) }

    it 'does not allow unauthorized' do
      put :reject, id: invitation.id
      expect(response).to be_unauthorized
    end
    
    it 'does not allow random' do
      set_token random.token
      put :reject, id: invitation.id
      expect(response).to be_forbidden
    end

    it 'does not allow owner' do
      set_token owner.token
      put :reject, id: invitation.id
      expect(response).to be_forbidden
    end

    it 'allows invited' do
      set_token invited.token
      put :reject, id: invitation.id
      expect(response).to be_success
      invitation.reload
      expect(invitation.rejected).to be true
    end

  end
end
