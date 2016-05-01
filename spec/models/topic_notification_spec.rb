require 'rails_helper'

RSpec.describe TopicNotification, type: :model do
  subject { TopicNotification.new }
  it { should validate_presence_of :topic }
end
