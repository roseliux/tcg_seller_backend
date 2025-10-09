require 'rails_helper'

RSpec.describe "/card_sets", type: :request do
  describe "GET /card_sets" do
    let!(:user) { create(:user) }
    let!(:session_user) { sign_in(user) }
    let!(:token) { session_user.last }
    let!(:pokemon_category) { create(:category, id: 'pokemon', name: 'Pokemon') }
    let!(:magic_category) { create(:category, id: 'magic', name: 'Magic: The Gathering') }
    let!(:base_set) { create(:card_set, id: 'base1', name: 'Base Set', category: pokemon_category) }
    let!(:jungle_set) { create(:card_set, id: 'jungle1', name: 'Jungle', category: pokemon_category) }
    let!(:alpha_set) { create(:card_set, id: 'alpha', name: 'Alpha', category: magic_category) }

    context "without search parameter" do
      it "returns all card sets ordered by name" do
        get "/card_sets", headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        card_sets = json_response
        expect(card_sets).to be_an(Array)
        expect(card_sets.size).to eq(3)

        # Should be ordered by name
        expect(card_sets.map { |cs| cs[:name] }).to eq(['Alpha', 'Base Set', 'Jungle'])
      end
    end

    context "with search parameter" do
      it "filters card sets by name (case insensitive)" do
        get "/card_sets", params: { q: "base" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        card_sets = json_response
        expect(card_sets).to be_an(Array)
        expect(card_sets.size).to eq(1)
        expect(card_sets.first[:name]).to eq('Base Set')
      end

      it "returns multiple matches when search term matches multiple sets" do
        get "/card_sets", params: { q: "a" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        card_sets = json_response
        expect(card_sets).to be_an(Array)
        expect(card_sets.size).to eq(2)
        expect(card_sets.map { |cs| cs[:name] }).to contain_exactly('Alpha', 'Base Set')
      end

      it "returns empty array when no matches found" do
        get "/card_sets", params: { q: "nonexistent" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        card_sets = json_response
        expect(card_sets).to be_an(Array)
        expect(card_sets.size).to eq(0)
      end

      it "handles empty search parameter" do
        get "/card_sets", params: { q: "" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        card_sets = json_response
        expect(card_sets).to be_an(Array)
        expect(card_sets.size).to eq(3)
      end
    end
  end
end
