require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.build(:user) }

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:user_name) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_uniqueness_of(:user_name).case_insensitive }
    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("invalid-email").for(:email) }
    it { should validate_length_of(:password).is_at_least(12) }
    it { should validate_length_of(:user_name).is_at_least(3).is_at_most(40) }
    it { should allow_value("valid_username").for(:user_name) }
    it { should allow_value("user123").for(:user_name) }
    it { should allow_value("user_name_123").for(:user_name) }
    it { should_not allow_value("invalid-username").for(:user_name) }
    it { should_not allow_value("invalid username").for(:user_name) }
    it { should_not allow_value("invalid@username").for(:user_name) }
    it { should have_secure_password }
  end

  describe "associations" do
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe "factory" do
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end

    it "creates valid traits" do
      expect(FactoryBot.build(:user, :john_doe)).to be_valid
      expect(FactoryBot.build(:user, :jane_smith)).to be_valid
      expect(FactoryBot.build(:user, :unverified)).to be_valid
    end
  end

  describe "validations in detail" do
    let(:user) { FactoryBot.build(:user) }

    context "when email is missing" do
      it "is invalid" do
        user.email = nil
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("can't be blank")
      end
    end

    context "when email is duplicate" do
      it "is invalid" do
        FactoryBot.create(:user, email: "test@example.com")
        duplicate_user = FactoryBot.build(:user, email: "TEST@EXAMPLE.COM")
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email]).to include("has already been taken")
      end
    end

    context "when email has invalid format" do
      it "is invalid" do
        user.email = "invalid-email"
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("is invalid")
      end
    end

    context "when password is too short" do
      it "is invalid" do
        user.password = "short"
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("is too short (minimum is 12 characters)")
      end
    end

    context "when first_name is missing" do
      it "is invalid" do
        user.first_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:first_name]).to include("can't be blank")
      end
    end

    context "when last_name is missing" do
      it "is invalid" do
        user.last_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:last_name]).to include("can't be blank")
      end
    end

    context "when user_name is missing" do
      it "is invalid" do
        user.user_name = nil
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("can't be blank")
      end
    end

    context "when user_name is duplicate" do
      it "is invalid" do
        FactoryBot.create(:user, user_name: "testuser")
        duplicate_user = FactoryBot.build(:user, user_name: "TESTUSER")
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:user_name]).to include("has already been taken")
      end
    end

    context "when user_name has invalid format" do
      it "is invalid with special characters" do
        user.user_name = "invalid-name"
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("can only contain letters, numbers, and underscores")
      end

      it "is invalid with spaces" do
        user.user_name = "invalid name"
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("can only contain letters, numbers, and underscores")
      end

      it "is invalid with special symbols" do
        user.user_name = "invalid@name"
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("can only contain letters, numbers, and underscores")
      end
    end

    context "when user_name is too short" do
      it "is invalid" do
        user.user_name = "ab"
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("is too short (minimum is 3 characters)")
      end
    end

    context "when user_name is too long" do
      it "is invalid" do
        user.user_name = "a" * 41
        expect(user).not_to be_valid
        expect(user.errors[:user_name]).to include("is too long (maximum is 40 characters)")
      end
    end

    context "when all required fields are present" do
      it "is valid" do
        expect(user).to be_valid
      end
    end
  end

  describe "normalization" do
    it "downcases email before saving" do
      user = FactoryBot.create(:user, email: "TEST@EXAMPLE.COM")
      expect(user.reload.email).to eq("test@example.com")
    end

    it "downcases user_name before saving" do
      user = FactoryBot.create(:user, user_name: "TestUser")
      expect(user.reload.user_name).to eq("testuser")
    end

    it "strips whitespace from email" do
      user = FactoryBot.create(:user, email: "  test@example.com  ")
      expect(user.reload.email).to eq("test@example.com")
    end

    it "strips whitespace from user_name" do
      user = FactoryBot.create(:user, user_name: "  testuser  ")
      expect(user.reload.user_name).to eq("testuser")
    end
  end

  describe "instance methods" do
    let(:user) { FactoryBot.build(:user, first_name: "John", last_name: "Doe", user_name: "johndoe") }

    describe "#full_name" do
      it "returns first and last name combined" do
        expect(user.full_name).to eq("John Doe")
      end
    end

    describe "#display_name" do
      it "returns username with @ prefix" do
        expect(user.display_name).to eq("@johndoe")
      end
    end
  end

  describe "password authentication" do
    let(:user) { FactoryBot.create(:user, password: "password123456") }

    it "authenticates with correct password" do
      expect(user.authenticate("password123456")).to eq(user)
    end

    it "fails authentication with incorrect password" do
      expect(user.authenticate("wrongpassword")).to be_falsey
    end

    it "allows blank password for existing users when not changing password" do
      user.save! # Save the user first
      user.reload
      user.first_name = "Updated Name" # Change something else, not password
      expect(user).to be_valid
    end
  end

  describe "email verification" do
    let(:user) { FactoryBot.create(:user) }

    it "generates email verification token" do
      token = user.generate_token_for(:email_verification)
      expect(token).to be_present
    end

    it "can verify email verification token" do
      token = user.generate_token_for(:email_verification)
      expect(User.find_by_token_for(:email_verification, token)).to eq(user)
    end

    it "invalidates email verification when email changes" do
      user.update!(verified: true)
      expect(user.verified).to be true

      user.update!(email: "newemail@example.com")
      expect(user.verified).to be false
    end
  end

  describe "password reset" do
    let(:user) { FactoryBot.create(:user) }

    it "generates password reset token" do
      token = user.generate_token_for(:password_reset)
      expect(token).to be_present
    end

    it "can verify password reset token" do
      token = user.generate_token_for(:password_reset)
      expect(User.find_by_token_for(:password_reset, token)).to eq(user)
    end
  end

  describe "session management" do
    let(:user) { FactoryBot.create(:user) }

    it "can create sessions" do
      expect { user.sessions.create! }.to change(Session, :count).by(1)
    end

    it "destroys sessions when user is destroyed" do
      user.sessions.create!
      expect { user.destroy }.to change(Session, :count).by(-1)
    end

    it "destroys other sessions when password changes" do
      # Create multiple sessions
      session1 = user.sessions.create!
      session2 = user.sessions.create!

      # Simulate current session (this should not be deleted)
      allow(Current).to receive(:session).and_return(session1)

      # Change password
      user.update!(password: "newpassword123456", password_confirmation: "newpassword123456")

      # Check that other sessions were deleted but current session remains
      expect(Session.exists?(session1.id)).to be true
      expect(Session.exists?(session2.id)).to be false
    end
  end

  describe "scope and class methods" do
    it "can authenticate by email and password" do
      user = FactoryBot.create(:user, email: "test@example.com", password: "password123456")
      authenticated_user = User.authenticate_by(email: "test@example.com", password: "password123456")
      expect(authenticated_user).to eq(user)
    end

    it "returns nil for invalid credentials" do
      FactoryBot.create(:user, email: "test@example.com", password: "password123456")
      authenticated_user = User.authenticate_by(email: "test@example.com", password: "wrongpassword")
      expect(authenticated_user).to be_nil
    end

    it "is case insensitive for email authentication" do
      user = FactoryBot.create(:user, email: "test@example.com", password: "password123456")
      authenticated_user = User.authenticate_by(email: "TEST@EXAMPLE.COM", password: "password123456")
      expect(authenticated_user).to eq(user)
    end
  end
end
