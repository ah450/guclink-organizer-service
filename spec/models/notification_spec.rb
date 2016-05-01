require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to :sender }
  it { should belong_to :receiver }
end
