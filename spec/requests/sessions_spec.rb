require 'rails_helper'

RSpec.describe "User Authentication", type: :request do
  let(:user) { create(:user, :john_doe, password: "password123456") }

  describe "POST /sign_in" do
    context "with valid credentials" do
      it "returns success status" do
        post "/sign_in", params: {
          email: user.email,
          password: "password123456"
        }

        expect(response).to have_http_status(:created)
      end

      it "creates a new session" do
        expect {
          post "/sign_in", params: {
            email: user.email,
            password: "password123456"
          }
        }.to change(Session, :count).by(1)
      end

      it "returns session data" do
        post "/sign_in", params: {
          email: user.email,
          password: "password123456"
        }

        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to be_present
        expect(json_response["user_id"]).to eq(user.id)
      end

      it "sets session token in header" do
        post "/sign_in", params: {
          email: user.email,
          password: "password123456"
        }

        expect(response.headers["X-Session-Token"]).to be_present
      end

      it "works with case-insensitive email" do
        post "/sign_in", params: {
          email: user.email.upcase,
          password: "password123456"
        }

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid email" do
      it "returns unauthorized status" do
        post "/sign_in", params: {
          email: "wrong@example.com",
          password: "password123456"
        }

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post "/sign_in", params: {
          email: "wrong@example.com",
          password: "password123456"
        }

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("That email or password is incorrect")
      end

      it "does not create a session" do
        expect {
          post "/sign_in", params: {
            email: "wrong@example.com",
            password: "password123456"
          }
        }.not_to change(Session, :count)
      end
    end

    context "with invalid password" do
      it "returns unauthorized status" do
        post "/sign_in", params: {
          email: user.email,
          password: "wrongpassword"
        }

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post "/sign_in", params: {
          email: user.email,
          password: "wrongpassword"
        }

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("That email or password is incorrect")
      end
    end

    context "with missing parameters" do
      it "returns unauthorized when email is missing" do
        post "/sign_in", params: {
          password: "password123456"
        }

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized when password is missing" do
        post "/sign_in", params: {
          email: user.email
        }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /sign_out" do
    context "with valid session token" do
      it "signs out successfully" do
        _, token = sign_in(user)

        expect {
          delete "/sign_out", headers: auth_headers(token)
        }.to change(Session, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end

      it "destroys the current session" do
        _, token = sign_in(user)
        session = Session.find_signed(token)

        delete "/sign_out", headers: auth_headers(token)

        expect(Session.exists?(session.id)).to be false
      end

      it "returns success even with valid token" do
        _, token = sign_in(user)

        delete "/sign_out", headers: auth_headers(token)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "without session token" do
      it "returns unauthorized" do
        delete "/sign_out"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid session token" do
      it "returns unauthorized" do
        delete "/sign_out", headers: auth_headers("invalid_token")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "Session-based authentication" do
    describe "GET /sessions" do
      context "with valid session token" do
        it "returns user sessions" do
          test_user = create(:user, :john_doe, password: "password123456")
          _, token = sign_in(test_user)

          get "/sessions", headers: auth_headers(token)

          expect(response).to have_http_status(:ok)
          json_response = JSON.parse(response.body)
          expect(json_response).to be_an(Array)
          expect(json_response.length).to eq(1)
        end
      end

      context "without session token" do
        it "returns unauthorized" do
          get "/sessions"
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "with invalid session token" do
        it "returns unauthorized" do
          get "/sessions", headers: {
            "Authorization" => "Bearer invalid_token"
          }
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    describe "DELETE /sessions/:id" do
      let(:test_user) do
        create(:user,
          email: "isolated_user_#{SecureRandom.hex(10)}@example.com",
          password: "password123456"
        )
      end

      context "with valid session token" do
        it "allows user to delete their own session" do
          _, session_token = sign_in(test_user)
          test_session = test_user.sessions.last

          delete "/sessions/#{test_session.id}", headers: auth_headers(session_token)

          expect(response).to have_http_status(:no_content)
          expect(Session.exists?(test_session.id)).to be false
        end

        it "returns success status"  do
          _, token = sign_in(test_user)
          session_to_delete = test_user.sessions.last

          delete "/sessions/#{session_to_delete.id}", headers: auth_headers(token)
          expect(response).to have_http_status(:no_content)
        end
      end

      context "without session token" do
        it "returns unauthorized" do
          sign_in(test_user)
          session_to_delete = test_user.sessions.last

          delete "/sessions/#{session_to_delete.id}"
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end
end
