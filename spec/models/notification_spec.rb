require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should belong_to :sender }
  it { should belong_to :receiver }
end
