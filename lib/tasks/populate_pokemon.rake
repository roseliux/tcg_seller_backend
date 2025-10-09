require_relative "../data_loaders/json_loader"

namespace :db_pokemon do
  desc "Populate database with Trading Card Game data from JSON files"
  task populate_card_sets: :environment do
    pokemon = Category.find_or_create_by(id: "pokemon", name: "Pokemon")
    card_sets = DataLoaders::JsonLoader.load_data_file("pokemon-tcg-data/sets/en.json")

    card_sets.each do |card_set|
      CardSet.find_or_create_by(id: card_set["id"]) do |set|
        set.name = card_set["name"]
        set.release_date = card_set["releaseDate"]
        set.category_id = pokemon.id
        puts "  📂 Creating card set: #{card_set['name']}"
      end
    end
    puts "✅ Card sets population completed! Total card sets: #{CardSet.count}"
  end

  desc "Populate database with Pokemon cards from JSON files"
  task populate_cards: :environment do
    puts "🎴 Starting Pokemon cards population..."

    card_set = CardSet.find_by(id: "base1")
    category = Category.find_by(id: "pokemon")

    unless card_set && category
      puts "❌ Required CardSet or Category not found. Please run db:populate_card_sets first."
      next
    end

    card_files = Dir.glob(Rails.root.join("db", "data", "pokemon-tcg-data", "cards", "en", "*.json"))
    created_cards = 0

    card_files.each do |file_path|
      cards = DataLoaders::JsonLoader.load_data_file(file_path)
      file_name = File.basename(file_path, ".json") # name of the set from file
      card_set = CardSet.find_by(id: file_name)
      puts "  📄 Processing file: #{file_name} with #{cards.size} cards"

      cards.each do |card_data|
        Card.find_or_create_by(id: card_data["id"]) do |card|
          card.name = card_data["name"]
          card.card_set = card_set
          card.category = card_set.category
          created_cards += 1
          puts "  🃏 Creating card: #{card.name} (#{card.id})"
        end
      end
    end
    puts "✅ Cards population completed! Total new cards added: #{created_cards}"
  end
end
