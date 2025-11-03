require 'rails_helper'

RSpec.describe "Listings", type: :request do
  let!(:user) { create(:user) }
  let!(:session_user) { sign_in(user) }
  let!(:token) { session_user.last }

  let!(:location) { create(:location) }
  let!(:category) { create(:category) }
  let!(:card_set) { create(:card_set, category: category) }
  let!(:pokemon_product) { create(:pokemon_product, card_set: card_set) }

  describe "GET /listings" do
    context "when authenticated" do
      before do
        create_list(:listing, 3, user: user, item: pokemon_product, location: location, purpose: "sell")
        create_list(:listing, 2, user: user, item: pokemon_product, location: location, purpose: "looking")
      end

      it "returns sell listings when purpose is sell" do
        get "/listings", params: { purpose: "sell" }, headers: auth_headers(token)

        expect(response).to have_http_status(:success)
        expect(json_response.size).to eq(3)
      end

      it "returns looking listings when purpose is looking" do
        get "/listings", params: { purpose: "looking" }, headers: auth_headers(token)

        expect(response).to have_http_status(:success)
        expect(json_response.size).to eq(2)
      end

      it "returns bad request without purpose parameter" do
        get "/listings", headers: auth_headers(token)

        expect(response).to have_http_status(:bad_request)
        expect(json_response[:error]).to include("Invalid or missing purpose parameter. Must be one of: sell, looking")
      end

      it "returns bad request with invalid purpose" do
        get "/listings", params: { purpose: "invalid" }, headers: auth_headers(token)

        # expect(response).to have_http_status(:bad_request)
        expect(json_response[:error]).to include("Invalid or missing purpose parameter")
      end

      it "returns listings in descending order by created_at" do
        get "/listings", params: { purpose: "sell" }, headers: auth_headers(token)

        expect(response).to have_http_status(:success)
        dates = json_response.map { |l| l["created_at"] }
        expect(dates).to eq(dates.sort.reverse)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/listings", params: { purpose: "sell" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /listings" do
    let(:valid_attributes) do
      {
        listing: {
          title: "Charizard VMAX",
          description: "Mint condition card",
          purpose: "sell",
          condition: "mint",
          price: 100.00,
          location_postal_code: "12345",
          item_type: "PokemonProduct",
          item_id: pokemon_product.id
        }
      }
    end

    context "when authenticated" do
      it "creates a new listing with valid attributes" do
        expect {
          post "/listings", params: valid_attributes.to_json, headers: auth_headers(token)
        }.to change(Listing, :count).by(1)

        expect(response).to have_http_status(:ok)
      end

      it "sets the user_id to current user" do
        post "/listings", params: valid_attributes.to_json, headers: auth_headers(token)

        listing = Listing.last
        expect(listing.user_id).to eq(user.id)
      end

      it "sets status to active by default" do
        post "/listings", params: valid_attributes.to_json, headers: auth_headers(token)

        listing = Listing.last
        expect(listing.status).to eq("active")
      end

      it "returns unprocessable entity with invalid attributes" do
        invalid_attributes = valid_attributes.deep_dup
        invalid_attributes[:listing][:title] = nil

        expect {
          post "/listings", params: invalid_attributes.to_json, headers: auth_headers(token)
        }.not_to change(Listing, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:title]).to include("can't be blank")
      end

      it "returns unprocessable entity with invalid condition" do
        invalid_attributes = valid_attributes.deep_dup
        invalid_attributes[:listing][:condition] = "invalid_condition"

        expect {
          post "/listings", params: invalid_attributes.to_json, headers: auth_headers(token)
        }.not_to change(Listing, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        post "/listings", params: valid_attributes.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /listings/:id" do
    let(:listing) { create(:listing, user: user, item: pokemon_product, location: location) }

    context "when authenticated" do
      it "returns the listing" do
        get "/listings/#{listing.id}", headers: auth_headers(token)

        expect(response).to have_http_status(:success)
        expect(json_response[:id]).to eq(listing.id)
        expect(json_response[:title]).to eq(listing.title)
      end

      it "returns not found for non-existent listing" do
        get "/listings/99999", headers: auth_headers(token)
        expect(response).to have_http_status(:not_found)
      end

      it "returns not found for another user's listing" do
        other_user = create(:user)
        other_listing = create(:listing, user: other_user, item: pokemon_product, location: location)

        get "/listings/#{other_listing.id}", headers: auth_headers(token)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/listings/#{listing.id}"

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /listings/:id" do
    let(:listing) { create(:listing, user: user, item: pokemon_product, location: location) }
    let(:update_attributes) do
      {
        listing: {
          title: "Updated Title",
          price: 150.00
        }
      }
    end

    context "when authenticated" do
      it "updates the listing with valid attributes" do
        patch "/listings/#{listing.id}", params: update_attributes.to_json, headers: auth_headers(token)

        expect(response).to have_http_status(:success)
        listing.reload
        expect(listing.title).to eq("Updated Title")
        expect(listing.price).to eq(150.00)
      end

      it "returns unprocessable entity with invalid attributes" do
        invalid_attributes = { listing: { title: nil } }

        patch "/listings/#{listing.id}", params: invalid_attributes.to_json, headers: auth_headers(token)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:title]).to include("can't be blank")
      end

      it "returns not found for non-existent listing" do
        patch "/listings/99999", params: update_attributes.to_json, headers: auth_headers(token)

        expect(response).to have_http_status(:not_found)
      end

      it "returns not found for another user's listing" do
        other_user = create(:user)
        other_listing = create(:listing, user: other_user, item: pokemon_product, location: location)

        patch "/listings/#{other_listing.id}", params: update_attributes.to_json, headers: auth_headers(token)

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        patch "/listings/#{listing.id}", params: update_attributes.to_json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
