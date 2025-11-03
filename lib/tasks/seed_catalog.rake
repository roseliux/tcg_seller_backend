# lib/tasks/seed_catalog.rake
namespace :db do
  desc "Populate basic categories and products for TCG marketplace"
  task seed_catalog: :environment do
    puts "🎮 Starting TCG Catalog Seeding..."

    # Create Categories
    puts "\n📚 Creating Categories..."

    ["pokemon", "magic", "yugioh", "one_piece", "lorcana"].each do |category_id|
      Category.find_or_create_by!(id: category_id) do |c|
        c.name = category_id.humanize
        puts "  ✓ Created #{c.name} category"
      end
    end

    # Create Pokemon Products
    puts "\n🎴 Creating Pokemon Products..."
    ["Card", "Sealed", "Deck", "Bulk", "Accessory", "Other"].each do |product_type|
      BasicProduct.find_or_create_by!(
        name: product_type,
      ) do |p|
        p.product_type = product_type.downcase.gsub(" ", "_")
        puts "  ✓ Created Product #{product_type}"
      end
    end


    # Statistics
    puts "\n📊 Seeding Summary:"
    puts "  Categories: #{Category.count}"
    puts "  BasicProducts: #{BasicProduct.count}"

    puts "\n✅ TCG Catalog seeding completed successfully!"
  end
end
