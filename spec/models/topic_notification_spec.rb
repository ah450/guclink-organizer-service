require 'rails_helper'

RSpec.describe TopicNotification, type: :model do
  it { should validate_presence_of :topic }
end
