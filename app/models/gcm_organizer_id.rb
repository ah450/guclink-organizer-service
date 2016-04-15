class GcmOrganizerId < ActiveRecord::Base
  belongs_to :user
  validates :user, :gcm, presence: true
  validates :user, :gcm, uniqueness: true
end
