require 'rails_helper'

RSpec.describe "User Registration", type: :request do
  describe "POST /sign_up" do
    let(:valid_params) do
      {
        email: "test@example.com",
        password: "password123456",
        password_confirmation: "password123456",
        first_name: "Test",
        last_name: "User",
        user_name: "testuser"
      }
    end

    context "with valid parameters" do
      it "creates a new user" do
        expect {
          post "/sign_up", params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns created status" do
        post "/sign_up", params: valid_params
        expect(response).to have_http_status(:created)
      end

      it "returns user data" do
        post "/sign_up", params: valid_params

        json_response = JSON.parse(response.body)
        expect(json_response["email"]).to eq("test@example.com")
        expect(json_response["first_name"]).to eq("Test")
        expect(json_response["last_name"]).to eq("User")
        expect(json_response["user_name"]).to eq("testuser")
        expect(json_response["verified"]).to eq(false) # Email not verified initially
      end

      it "does not return password in response" do
        post "/sign_up", params: valid_params

        json_response = JSON.parse(response.body)
        expect(json_response).not_to have_key("password")
        expect(json_response).not_to have_key("password_digest")
      end
    end

    context "with invalid email" do
      it "returns validation errors" do
        post "/sign_up", params: valid_params.merge(email: "invalid-email")

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["email"]).to include("is invalid")
      end
    end

    context "with duplicate email" do
      it "returns validation errors" do
        FactoryBot.create(:user, email: "test@example.com")

        post "/sign_up", params: valid_params

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["email"]).to include("has already been taken")
      end
    end

    context "with duplicate user_name" do
      it "returns validation errors" do
        FactoryBot.create(:user, user_name: "testuser")

        post "/sign_up", params: valid_params

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["user_name"]).to include("has already been taken")
      end
    end

    context "with short password" do
      it "returns validation errors" do
        post "/sign_up", params: valid_params.merge(
          password: "short",
          password_confirmation: "short"
        )

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["password"]).to include("is too short (minimum is 12 characters)")
      end
    end

    context "with password confirmation mismatch" do
      it "returns validation errors" do
        post "/sign_up", params: valid_params.merge(password_confirmation: "different")

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["password_confirmation"]).to include("doesn't match Password")
      end
    end

    context "with missing required fields" do
      it "returns validation errors for missing first_name" do
        post "/sign_up", params: valid_params.except(:first_name)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["first_name"]).to include("can't be blank")
      end

      it "returns validation errors for missing user_name" do
        post "/sign_up", params: valid_params.except(:user_name)

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["user_name"]).to include("can't be blank")
      end
    end

    context "with invalid user_name format" do
      it "returns validation errors for special characters" do
        post "/sign_up", params: valid_params.merge(user_name: "test-user")

        expect(response).to have_http_status(:unprocessable_content)
        json_response = JSON.parse(response.body)
        expect(json_response["user_name"]).to include("can only contain letters, numbers, and underscores")
      end
    end
  end
end
