require_relative "../data_loaders/json_loader"

namespace :db do
  desc "Populate database with Trading Card Game data from JSON files"
  desc "Show available JSON data files"
  task :show_data_files, [:folder] => :environment do |t, args|
    # Default folder or use parameter
    folder_path = args[:folder] || "pokemon-tcg-data/sets"
    data_dir = Rails.root.join("db", "data", folder_path)

    puts "📁 Available JSON data files in: db/data/#{folder_path}"

    if Dir.exist?(data_dir)
      json_files = Dir[data_dir.join("*.json")]

      if json_files.any?
        puts "   Found #{json_files.length} JSON files:"
        json_files.each do |file|
          file_size = File.size(file)
          puts "   #{File.basename(file)} (#{file_size} bytes)"

          # Show basic structure
          begin
            data = JSON.parse(File.read(file))
            if data.is_a?(Hash)
              puts "     Keys: #{data.keys.join(', ')}"
            elsif data.is_a?(Array)
              puts "     Array with #{data.length} items"
            end
          rescue JSON::ParserError
            puts "     ⚠️  Invalid JSON format"
          end
        end
      else
        puts "   No JSON files found in #{data_dir}"
      end
    else
      puts "   📂 Directory not found: #{data_dir}"
      puts "   💡 Available options:"
      puts "      - Create directory: mkdir -p #{data_dir}"
      puts "      - Use different folder: rake db:show_data_files[your_folder_name]"

      # Show what directories do exist
      base_data_dir = Rails.root.join("db", "data")
      if Dir.exist?(base_data_dir)
        subdirs = Dir[base_data_dir.join("*/")].map { |d| File.basename(d) }
        if subdirs.any?
          puts "      - Available subdirectories: #{subdirs.join(', ')}"
        end
      end
    end
  end

  desc "Validate JSON data files"
  task :validate_data_files, [:folder] => :environment do |t, args|
    folder_path = args[:folder] || "pokemon-tcg-data/sets"
    data_dir = Rails.root.join("db", "data", folder_path)

    puts "🔍 Validating JSON data files in: db/data/#{folder_path}"

    # Check if directory exists and get all JSON files
    if Dir.exist?(data_dir)
      files_to_check = Dir[data_dir.join("*.json")]
    else
      puts "❌ Directory not found: #{data_dir}"
      return
    end

    valid_files = 0

    if files_to_check.empty?
      puts "📂 No JSON files found in directory"
      return
    end

    files_to_check.each do |file|
      begin
        data = JSON.parse(File.read(file))
        puts "✅ #{File.basename(file)} - Valid JSON"
        valid_files += 1

        # Show file structure info
        if data.is_a?(Hash)
          puts "   📋 Keys: #{data.keys.join(', ')}"

          # Special validation for known structures
          if data["card_sets"] && data["card_sets"].is_a?(Array)
            puts "   📦 Found #{data['card_sets'].length} card sets"
            total_categories = data["card_sets"].sum { |set| set["categories"]&.length || 0 }
            puts "   📂 Found #{total_categories} total categories"
          elsif data["data"] && data["data"].is_a?(Array)
            puts "   🎯 Found #{data['data'].length} data items"
          end
        elsif data.is_a?(Array)
          puts "   📊 Array with #{data.length} items"
        end

      rescue JSON::ParserError => e
        puts "❌ #{File.basename(file)} - Invalid JSON: #{e.message}"
      end
    end

    puts "\n📊 Validation Summary: #{valid_files}/#{files_to_check.length} files valid"
  end

  desc "Show usage examples for JSON data tasks"
  task :json_data_help do
    puts <<~HELP
      📚 JSON Data Tasks Usage Examples

      🔍 Show files in default folder (pokemon-tcg-data/sets):
        bundle exec rake db:show_data_files

      🔍 Show files in custom folder:
        bundle exec rake db:show_data_files[tcg_sets]
        bundle exec rake db:show_data_files[pokemon-tcg-data/cards]
        bundle exec rake db:show_data_files[custom_data]

      ✅ Validate files in default folder:
        bundle exec rake db:validate_data_files

      ✅ Validate files in custom folder:
        bundle exec rake db:validate_data_files[tcg_sets]
        bundle exec rake db:validate_data_files[pokemon-tcg-data/sets]

      🎴 Populate categories:
        bundle exec rake db:populate_categories_from_json

      📁 Directory Structure Examples:
        db/data/
        ├── tcg_sets.json                    # Default location
        ├── sample_products.json             # Default location
        ├── pokemon-tcg-data/
        │   └── sets/                        # Pokemon API data
        │       ├── base1.json
        │       └── base2.json
        ├── custom_data/
        │   ├── magic_sets.json
        │   └── yugioh_cards.json
        └── imports/
            └── bulk_data.json

      💡 Tips:
        - Use folders to organize different data sources
        - Keep related files together
        - Use descriptive folder names
        - Validate before populating

    HELP
  end

  desc "Populate categories from JSON files"
  task populate_categories_from_json: :environment do
    categories = DataLoaders::JsonLoader.load_data_file("categories.json")

    categories.each do |category|
      Category.find_or_create_by(id: category["id"]) do |cat|
        cat.name = category["name"]
        # cat.description = category['description']
        puts "  📂 Creating category: #{category['name']}"
      end
    end
    puts "✅ Categories population completed! Total categories: #{Category.count}"
  end
end
