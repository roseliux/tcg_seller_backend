require 'rails_helper'

RSpec.describe "/categories", type: :request do
  describe "GET /categories" do
    let!(:user) { create(:user) }
    let!(:session_user) { sign_in(user) }
    let!(:token) { session_user.last }
    let!(:pokemon_category) { create(:category, id: 'pokemon', name: 'Pokemon') }
    let!(:magic_category) { create(:category, id: 'magic', name: 'Magic: The Gathering') }
    let!(:yugioh_category) { create(:category, id: 'yugioh', name: 'Yu-Gi-Oh!') }

    it "returns all categories ordered by name" do
      get "/categories", headers: auth_headers(token)

      expect(response).to have_http_status(:ok)

      categories = json_response
      expect(categories).to be_an(Array)
      expect(categories.size).to eq(3)

      # Should be ordered by name
      expect(categories.map { |c| c[:name] }).to eq(['Magic: The Gathering', 'Pokemon', 'Yu-Gi-Oh!'])
    end

    it "returns proper category structure" do
      get "/categories", headers: auth_headers(token)

      expect(response).to have_http_status(:ok)

      categories = json_response
      first_category = categories.first

      expect(first_category).to have_key(:id)
      expect(first_category).to have_key(:name)
      expect(first_category).to have_key(:created_at)
      expect(first_category).to have_key(:updated_at)
    end

    it "requires authentication" do
      get "/categories"

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
