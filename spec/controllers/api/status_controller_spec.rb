require 'rails_helper'

RSpec.describe Api::StatusController, type: :controller do

  context 'index' do
    it 'returns status' do
      get :index, format: :json
      expect(response).to be_success
      expect(json_response[:redis_state]).to eql true
      expect(json_response[:db_state]).to eql true
    end
  end

end
