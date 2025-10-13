# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Create test users for mobile app testing
puts "Creating test users..."
User.destroy_all

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

test_users.each do |user_attrs|
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
end

# Create sessions for test users
puts "\nCreating test sessions..."
Session.destroy_all

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

puts "Finished creating test sessions!"
puts "\n" + "="*60
puts "MOBILE APP TEST CREDENTIALS"
puts "="*60

User.includes(:sessions).each do |user|
  session = user.sessions.first
  puts "Email: #{user.email}"
  puts "Password: password123456"
  puts "Token: #{session.signed_id}"
  puts "Authorization Header: Bearer #{session.signed_id}"
  puts "-" * 40
end

# category
category = Category.find_or_create_by!(id: 'pokemon', name: 'Pokemon')
card_set = CardSet.find_or_create_by!(id: 'base1', name: 'Base', category_id: 'pokemon', release_date: '1999-01-09')
# card = Card.find_or_create_by!(id: 'base1-1', name: 'Alakazam', card_set_id: 'base1', category_id: 'pokemon')

Listing.destroy_all
10.times do |i|
  Listing.find_or_create_by!(item_title: "Selling Alakazam #{i+1}", listing_type: 'selling', condition: 'mint', price: '1000', user: User.first, category: category, card_set: card_set)
  Listing.find_or_create_by!(item_title: "Looking for Alakazam #{i+1}", listing_type: 'looking', condition: 'mint', price: '1001', user: User.first, category: category, card_set: card_set)
end
