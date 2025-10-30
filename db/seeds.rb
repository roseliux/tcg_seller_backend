# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Create test users for mobile app testing

# Create test users for mobile app testing
puts "Cleaning up existing data..."
User.find_each(&:destroy)
Session.find_each(&:destroy)
Listing.find_each(&:destroy)

puts "Creating test users..."
test_users = [
  {
    email: "john.doe@example.com",
    password: "password123456",
    first_name: "John",
    last_name: "Doe",
    user_name: "johndoe",
    verified: true
  },
  {
    email: "jane.smith@example.com",
    password: "password123456",
    first_name: "Jane",
    last_name: "Smith",
    user_name: "janesmith",
    verified: true
  }
]

users = test_users.map do |user_attrs|
  user = User.find_or_create_by(email: user_attrs[:email]) do |u|
    u.password = user_attrs[:password]
    u.first_name = user_attrs[:first_name]
    u.last_name = user_attrs[:last_name]
    u.user_name = user_attrs[:user_name]
    u.verified = user_attrs[:verified]
  end

  if user.persisted?
    puts "✓ Created user: #{user.email} (#{user.user_name})"
  else
    puts "✗ Failed to create user: #{user_attrs[:email]} - #{user.errors.full_messages.join(', ')}"
  end
  user.id
end

# Create sessions for test users
puts "\nCreating test sessions..."
User.all.each do |user|
  # Create a session for each user
  session = user.sessions.create!(
    user_agent: "TCG Mobile App (Test)",
    ip_address: "127.0.0.1"
  )

  session_token = session.signed_id

  puts "✓ Created session for #{user.email}"
  puts "  User: #{user.first_name} #{user.last_name} (#{user.user_name})"
  puts "  Session Token: #{session_token}"
  puts "  Use this for Authorization header: Bearer #{session_token}"
  puts ""
end

# puts "Finished creating test sessions!"
# puts "\n" + "="*60
# puts "MOBILE APP TEST CREDENTIALS"
# puts "="*60

# User.includes(:sessions).each do |user|
#   session = user.sessions.first
#   puts "Email: #{user.email}"
#   puts "Password: password123456"
#   puts "Token: #{session.signed_id}"
#   puts "Authorization Header: Bearer #{session.signed_id}"
#   puts "-" * 40
# end

# category
category = Category.find_or_create_by!(id: 'pokemon', name: 'Pokemon')
card_set = CardSet.find_or_create_by!(id: 'base1', name: 'Base', category: category, release_date: '1999-01-09')
# card = Card.find_or_create_by!(id: 'base1-1', name: 'Alakazam', card_set: card_set, category: category)
card_location = Location.find_or_create_by!(name: 'Hermosillo, Sonora', country: 'Mexico', city: 'Hermosillo', state: 'Sonora', postal_code: '83224')

#  add pokemon products
#  Create a single card product (individual card)
pokemon_card = PokemonProduct.find_or_create_by(
  name: 'Alakazam - Base Set #1',
  product_type: 'card',
  card_set_id: 'base1',
  language: 'english',
)
# Create a booster box (sealed product with set)
booster_box = PokemonProduct.find_or_create_by(
  name: 'Scarlet & Violet Booster Box',
  product_type: 'booster_box',
  card_set_id: 'base1',
  language: 'english',
)

# Create bulk cards (no set required)
bulk = PokemonProduct.find_or_create_by(
  name: 'Mixed Pokemon Bulk',
  product_type: 'bulk',
  metadata: { condition: 'near_mint', includes_energies: true }
)

# Create a custom deck (optional set)
deck = PokemonProduct.find_or_create_by(
  name: 'Charizard Ex Competitive Deck',
  product_type: 'deck',
  metadata: {
    format: 'standard',
    strategy: 'aggro'
  }
)
puts "✓ Created Pokemon products."

100.times do |i|
  item = [pokemon_card, booster_box, bulk, deck].sample
  condition = ['mint', 'near_mint', 'excellent', 'good', 'light_played', 'played', 'poor'].sample
  Listing.find_or_create_by!(title: "Selling #{item.name} #{i+1}", purpose: 'sell', condition: condition, price: '1000', user_id: users.sample, item: item, location: card_location)
  Listing.find_or_create_by!(title: "Looking for #{item.name} #{i+1}", purpose: 'looking', condition: condition, price: '1001', user_id: users.sample, item: item, location: card_location)
end
puts "✓ Created Listings for Pokemon products."

puts "\nSeeding completed!"
