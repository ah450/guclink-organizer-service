require 'rails_helper'

RSpec.describe Api::ExamsController, type: :controller do
  let(:student) { FactoryGirl.create(:student) }
  let(:teacher) { FactoryGirl.create(:teacher) }

  context 'create' do
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
      expect(Exam).to receive(:parse_html) do
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'exams/ViewExamSeat.html')
        Nokogiri::HTML(open(path))
      end
      set_token student.token
      expect{
        post :create, format: :json, guc_username: 'ss', guc_password: 'ss'
        expect(response).to be_created
      }.to change(Exam, :count).by 8
    end
  end

  context 'index' do
    it 'does not allow unauthorized' do
      get :index, format: :json
      expect(response).to be_unauthorized
    end
    it 'does not allow teachers' do
      set_token teacher.token
      get :index, format: :json
      expect(response).to be_forbidden
    end
    it 'allows student' do
      expect(Exam).to receive(:parse_html) do
        path = File.join(Rails.root.join('spec/fixtures/files'),
                       'exams/ViewExamSeat.html')
        Nokogiri::HTML(open(path))
      end
      Exam.fetch_from_guc('s', 's', student).each(&:save)
      set_token student.token
      expect{
        get :index, format: :json
        expect(response).to be_success
        expect(json_response[:exams].size).to eql 8
      }.to change(Exam, :count).by 0
    end
  end


end
