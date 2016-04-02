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

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_secure_password }
  it { should have_many :reset_tokens }
  it { should have_many :verification_tokens }
  it { should validate_presence_of :email }
  it { should validate_presence_of :name }

  it 'has a valid student factory' do
    expect(FactoryGirl.build(:student)).to be_valid
  end

  it 'has a valid teacher factory' do
    expect(FactoryGirl.build(:teacher)).to be_valid
  end

  it 'has a valid super user faactory' do
    expect(FactoryGirl.build(:super_user)).to be_valid
  end

  context 'student' do

    context 'type detection' do
      let(:student) { FactoryGirl.build(:student) }
      it "should know it's a student" do
        student.save!
        expect(student.student?).to be true
      end
    end


    context 'Token generation' do
      let(:student) { FactoryGirl.create(:student) }
      it 'should be able to create a token' do
        expect(student.token).to be_a_kind_of String
      end
      it 'should be able to retrive a student by its token' do
        token = student.token
        expect(User.find_by_token(token)).to eql student
      end
    end

    context 'type scope' do
      let(:teachers) { FactoryGirl.create_list(:teacher, 10) }
      let(:students) { FactoryGirl.create_list(:student, 10) }
      it 'should query by teachers' do
        are_teachers = User.teachers.reduce(true) { |memo, user| memo && user.teacher? }
        expect(are_teachers).to be true
      end
      it 'should query by students' do
        are_students = User.students.reduce(true) { |memo, user| memo && user.student? }
        expect(are_students).to be true
      end
    end

  end

  context 'Teacher' do
    context 'validation' do
      let(:teacher) { FactoryGirl.build(:teacher) }
      it 'has a valid factory' do
        expect(teacher).to be_valid
      end
      context 'email is belongs to a non guc domain' do
        let(:teacher) { FactoryGirl.build(:teacher, email: 'teacher@example.com') }
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end
    end # Validations
    context 'type detection' do
      let(:teacher) { FactoryGirl.build(:teacher) }
      it "should know it's a teacher" do
        teacher.save!
        expect(teacher.teacher?).to be true
      end
    end

    context 'Token generation' do
      let(:teacher) { FactoryGirl.create(:teacher) }
      it 'should be able to create a token' do
        expect(teacher.token).to be_a_kind_of String
      end
      it 'should be able to retrive a teacher by its token' do
        token = teacher.token
        expect(User.find_by_token(token)).to eql teacher
      end
    end
end # Teacher specs


  context 'Password reset' do
    let(:student) { FactoryGirl.create(:student, password: 'old password') }
    it 'should generate reset token' do
      expect(student).to respond_to :gen_reset_token
    end
    it 'should not generate new tokens unecessarily' do
      token_one = student.gen_reset_token
      token_two = student.gen_reset_token
      expect(token_one).to eql token_two
    end

    it 'should reset password with generated token' do
      newPass = 'new password'
      token = student.gen_reset_token
      expect(student.reset_password(token, newPass)).to be true
      expect(student.authenticate(newPass)).to be_truthy
    end

    it 'should not reset password with another token' do
      newPass = 'new password'
      student.gen_reset_token
      other = FactoryGirl.create(:teacher)
      token = other.gen_reset_token
      expect(student.reset_password(token, newPass)).to be false
      expect(student.authenticate(newPass)).to be false
    end
  end

  context 'verification' do
    let(:teacher) { FactoryGirl.create(:teacher, verified: false) }
    it 'should generate verification token' do
      expect(teacher).to respond_to :gen_verification_token
    end
    it 'should not generate new tokens unecessarily' do
      token_one = teacher.gen_verification_token
      token_two = teacher.gen_verification_token
      expect(token_one).to eql token_two
    end

    it 'should accept generated token' do
      expect(teacher.verified?).to be false
      token = teacher.gen_verification_token
      expect(teacher.verify(token)).to be true
      expect(teacher.verified?).to be true
    end

    it 'should not accept another token' do
      expect(teacher.verified?).to be false
      teacher.gen_verification_token
      other = FactoryGirl.create(:student)
      other_token = other.gen_verification_token
      expect(teacher.verify(other_token)).to be false
      expect(teacher.verified?).to be false
    end
  end

  context '.full_name' do
    let(:user) { FactoryGirl.create(:student, name: 'i am a student') }
    it 'is capitalized' do
      expect(user.full_name).to eql 'I Am A Student'
    end
  end



end
