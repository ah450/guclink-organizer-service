require 'rails_helper'

RSpec.describe Api::CoursesController, type: :controller do
  context 'show' do
    let(:user) { FactoryGirl.create(:teacher) }
    let(:course) {  FactoryGirl.create(:course) }
    let(:student) { FactoryGirl.create(:student) }
    it 'does not allow unauthorized' do
      get :show, id: course.id
      expect(response).to be_unauthorized
    end
    it 'allows user' do
      set_token user.token
      get :show, id: course.id
      expect(response).to be_success
    end
    it 'allows registered student' do
      slot = FactoryGirl.create(:schedule_slot, course: course)
      reg = FactoryGirl.create(:student_registration, schedule_slot: slot, user: student)
      set_token student.token
      get :show, id: course.id
      expect(response).to be_success
    end
    it 'does not allow unregistered student' do
      set_token student.token
      get :show, id: course.id
      expect(response).to be_forbidden
    end
  end
  context 'index' do
    let(:student) { FactoryGirl.create(:student) }
    let(:teacher) { FactoryGirl.create(:teacher) }
    let(:registrations) { FactoryGirl.create_list(:student_registration, 3, user: student) }
    let(:other) { FactoryGirl.create_list(:student_registration, 2) }
    
    it 'does not allow unauthorized' do
      registrations
      other
      get :index
      expect(response).to be_unauthorized
    end

    it 'shows registered courses to students' do
      set_token student.token
      other
      registrations
      get :index, page_size: 200
      expect(response).to be_success
      expected_ids = registrations.map(&:schedule_slot).map(&:course).map(&:id)
      received_ids = json_response[:courses].map { |e|  e[:id] }
      expect(received_ids).to contain_exactly(*expected_ids)
    end

    it 'shows all courses to teachers' do
      set_token teacher.token
      other
      registrations
      get :index, page_size: 200
      expect(response).to be_success
      expected_ids = registrations.map(&:schedule_slot).map(&:course).map(&:id) + other.map(&:schedule_slot).map(&:course).map(&:id)
      received_ids = json_response[:courses].map { |e|  e[:id] }
      expect(received_ids).to contain_exactly(*expected_ids)
    end

  end
end
