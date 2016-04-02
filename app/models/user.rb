# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string
#  email           :string
#  password_digest :string           not null
#  student         :boolean          not null
#  verified        :boolean          default(FALSE), not null
#  super_user      :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  has_secure_password
  include JwtAuthenticatable
  include EmailVerifiable
  include PasswordResetable
  include Cacheable
  STUDENT_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@student.guc.edu.eg\z/
  TEACHER_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@guc.edu.eg\z/
  GUC_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@(student.)?guc.edu.eg\z/
  validates :password, length: { minimum: 2 }, allow_nil: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: GUC_EMAIL_REGEX,
                              message: 'must be a GUC email'
  validate :email_not_changed
  validate :super_user_teacher
  before_validation :set_subtype
  before_validation :downcase_email
  scope :students, -> { where student: true }
  scope :teachers, -> { where student: false }
  scope :admins, -> { where super_user: true }

  def teacher?
    !student?
  end

  def full_name
    name.split.map(&:capitalize).join ' '
  end

  def as_json(_options = {})
    super(except: [:password_digest])
  end

  private

  def super_user_teacher
    errors.add(:super_user, 'Must be a teacher') if student? && super_user?
  end

  def set_subtype
    self.student = (STUDENT_EMAIL_REGEX === email).to_s
  end

  def downcase_email
    self.email = email.downcase unless email.nil?
  end

  def email_not_changed
    errors.add(:email, 'can not be changed') if email_changed? && persisted?
  end
end
