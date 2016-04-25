require 'rails_helper'

RSpec.describe "fetching schedules", type: :request do
  let(:student) { FactoryGirl.create(:student) }
  it 'performs properly on multiple requests' do
    expect(ScheduleSlot).to receive(:parse_html) do
      path = File.join(Rails.root.join('spec/fixtures/files'),
                     'schedules/ahi.html')
      Nokogiri::HTML(open(path))
    end.twice
    post "/api/schedules.json", {guc_username: 'ss', guc_password: 'ss'}, get_token(student.token)
    expect(response).to be_created
    old_slots = json_response[:slots]

    expect {
      post "/api/schedules.json", {guc_username: 'ss', guc_password: 'ss'}, get_token(student.token)
      expect(response).to be_created
      expect(json_response[:slots].size).to eql old_slots.size
    }.to change(StudentFetchedInfo, :count).by(0).and change(ScheduleSlot, :count).by(0).and change(StudentRegistration, :count).by(0)
  end
end