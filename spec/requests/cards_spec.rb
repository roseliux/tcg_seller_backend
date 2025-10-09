require 'rails_helper'

RSpec.describe "/cards", type: :request do
  describe "GET /cards" do
    let!(:user) { create(:user) }
    let!(:session_user) { sign_in(user) }
    let!(:token) { session_user.last }
    let!(:pokemon_category) { create(:category, id: 'pokemon', name: 'Pokemon') }
    let!(:base_set) { create(:card_set, id: 'base1', name: 'Base Set', category: pokemon_category) }
    let!(:charizard) { create(:card, id: 'base1-4', name: 'Charizard', card_set: base_set, category: pokemon_category) }
    let!(:blastoise) { create(:card, id: 'base1-2', name: 'Blastoise', card_set: base_set, category: pokemon_category) }
    let!(:venusaur) { create(:card, id: 'base1-15', name: 'Venusaur', card_set: base_set, category: pokemon_category) }

    context "without search parameter" do
      it "returns all cards ordered by name" do
        get "/cards", headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(3)

        # Should be ordered by name
        expect(cards.map { |c| c[:name] }).to eq(['Blastoise', 'Charizard', 'Venusaur'])
      end
    end

    context "with search parameter" do
      it "filters cards by name (case insensitive)" do
        get "/cards", params: { q: "charizard" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(1)
        expect(cards.first[:name]).to eq('Charizard')
      end

      it "returns multiple matches when search term matches multiple cards" do
        get "/cards", params: { q: "a" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(3)
        expect(cards.map { |c| c[:name] }).to contain_exactly('Blastoise', 'Charizard', 'Venusaur')
      end

      it "returns empty array when no matches found" do
        get "/cards", params: { q: "pikachu" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(0)
      end

      it "handles empty search parameter" do
        get "/cards", params: { q: "" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(3)
      end

      it "performs partial matches" do
        get "/cards", params: { q: "char" }, headers: auth_headers(token)

        expect(response).to have_http_status(:ok)

        cards = json_response
        expect(cards).to be_an(Array)
        expect(cards.size).to eq(1)
        expect(cards.first[:name]).to eq('Charizard')
      end
    end
  end
end
