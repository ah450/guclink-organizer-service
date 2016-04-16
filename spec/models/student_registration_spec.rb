require 'rails_helper'

RSpec.describe StudentRegistration, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :schedule_slot }
  it { should belong_to :user }
  it { should belong_to :schedule_slot }
end
