require 'rails_helper'

RSpec.describe Api::SchedulesController, type: :controller do
  let(:student) { FactoryGirl.create(:student) }
  let(:teacher) { FactoryGirl.create(:teacher) }

  context '.create' do
    it 'does not allow unauthorized' do
      post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
      expect(response).to be_unauthorized
    end
    it 'does not allow teachers' do
      set_token teacher.token
      post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
      expect(response).to be_forbidden
    end

    it 'allows student' do
      expect(ScheduleSlot).to receive(:parse_html) do
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'schedules/ahi.html')
        Nokogiri::HTML(open(path))
      end
      set_token student.token
      post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
      expect(response).to be_created
    end

    it 'performs properly on multiple requests' do
      expect(ScheduleSlot).to receive(:parse_html) do
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'schedules/ahi.html')
        Nokogiri::HTML(open(path))
      end.twice
      set_token student.token
      post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
      expect(response).to be_created
      old_slots = json_response[:slots]

      expect {
        set_token student.token
        post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
        expect(response).to be_created
        expect(json_response[:slots].size).to eql old_slots.size
        }.to change(StudentFetchedInfo, :count).by(0).and change(ScheduleSlot, :count).by(0).and change(StudentRegistration, :count).by(0)
    end

  end
end
