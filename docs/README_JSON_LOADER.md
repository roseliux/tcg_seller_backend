# TCG JSON Data Management System

This system provides flexible JSON data management for populating the database with Trading Card Game data. It supports organized folder structures and parameterized rake tasks for different data sources.

## 📁 Flexible File Structure

```
db/data/
├── README.md                        # This documentation
├── tcg_sets.json                   # Custom card sets and categories
├── sample_products.json            # Sample products for each TCG
├── pokemon-tcg-data/               # Pokemon TCG API data
│   ├── sets/
│   │   └── en.json                 # Pokemon sets data (169 sets)
│   └── cards/
│       └── en/                     # Pokemon cards data
│           ├── base1.json          # Base Set cards
│           ├── base2.json          # Jungle cards
│           ├── sv1.json            # Scarlet & Violet cards
│           └── ... (169 sets)
├── magic-data/                     # Magic: The Gathering data
│   ├── sets/
│   └── cards/
├── yugioh-data/                    # Yu-Gi-Oh! data
│   ├── sets/
│   └── cards/
└── custom/                         # Your custom data
    ├── imports/
    └── exports/
```

## 🚀 Parameterized Rake Tasks

### **1. Show Available Files**

```bash
# Show files in default folder (pokemon-tcg-data/sets)
bundle exec rake db:show_data_files

# Show files in specific folder
bundle exec rake db:show_data_files[pokemon-tcg-data/cards/en]
bundle exec rake db:show_data_files[magic-data/sets]
bundle exec rake db:show_data_files[custom/imports]
bundle exec rake db:show_data_files[.]  # Root db/data directory
```

### **2. Validate JSON Files**

```bash
# Validate files in default folder
bundle exec rake db:validate_data_files

# Validate files in specific folder
bundle exec rake db:validate_data_files[pokemon-tcg-data/sets]
bundle exec rake db:validate_data_files[pokemon-tcg-data/cards/en]
```

### **3. Populate Database**

```bash
# Populate categories
bundle exec rake db:populate_categories_from_json

# Pokemon-specific population tasks
bundle exec rake db_pokemon:populate_card_sets    # Populate Pokemon card sets
bundle exec rake db_pokemon:populate_cards        # Populate Pokemon cards
```

### **4. Pokemon-Specific Tasks**

```bash
# Step 1: Populate Pokemon card sets (run this first)
bundle exec rake db_pokemon:populate_card_sets

# Step 2: Populate Pokemon cards (requires card sets to exist)
bundle exec rake db_pokemon:populate_cards
```

**Important Notes:**
- Run `populate_card_sets` before `populate_cards`
- Card sets task loads from `pokemon-tcg-data/sets/en.json`
- Cards task loads from all files in `pokemon-tcg-data/cards/en/*.json`
- Creates Pokemon category automatically if it doesn't exist

### **5. Get Help and Examples**

```bash
# Show comprehensive usage examples
bundle exec rake db:json_data_help
```

## 🔧 Enhanced JsonLoader Helper

### **Load Data with Folder Support**

```ruby
# Using the JsonLoader helper
require 'data_loaders/json_loader'

# Load specific file from root db/data/
tcg_data = DataLoaders::JsonLoader.load_data_file('tcg_sets.json')

# Load specific file from subfolder
pokemon_data = DataLoaders::JsonLoader.load_data_file('base1.json', 'pokemon-tcg-data/cards/en')

# Load all files from root directory
all_data = DataLoaders::JsonLoader.load_all_data_files

# Load all files from specific folder
pokemon_sets = DataLoaders::JsonLoader.load_all_data_files('pokemon-tcg-data/sets')

# Get available files in specific folder
files = DataLoaders::JsonLoader.available_files('pokemon-tcg-data/cards/en')

# Get available subdirectories
folders = DataLoaders::JsonLoader.available_folders
```

## 📋 Supported JSON File Formats

### **1. Custom TCG Sets Format** (`tcg_sets.json`)

```json
{
  "card_sets": [
    {
      "name": "Magic: The Gathering",
      "categories": [
        {
          "name": "Standard Sets",
          "release_date": "2023-01-01",
          "description": "Current Standard legal sets"
        }
      ]
    }
  ]
}
```

**Required Fields:**
- `name` (string): Card set name
- `categories[].name` (string): Category name
- `categories[].release_date` (string): ISO date format

**Optional Fields:**
- `categories[].description` (string): Category description

### **2. Pokemon TCG API Format** (`pokemon-tcg-data/`)

```json
{
  "data": [
    {
      "id": "base1",
      "name": "Base Set",
      "series": "Base",
      "printedTotal": 102,
      "total": 102,
      "legalities": {
        "unlimited": "Legal"
      },
      "releaseDate": "1999/01/09",
      "updatedAt": "2020/08/14 09:35:00",
      "images": {
        "symbol": "https://images.pokemontcg.io/base1/symbol.png",
        "logo": "https://images.pokemontcg.io/base1/logo.png"
      }
    }
  ]
}
```

### **3. Sample Products Format** (`sample_products.json`)

```json
{
  "pokemon_products": [
    {
      "name": "Charizard ex",
      "product_type": "single_card",
      "rarity": "double_rare",
      "category": "Scarlet & Violet",
      "price_range": {
        "low": 15.00,
        "market": 25.00,
        "high": 40.00
      }
    }
  ]
}
```

**Required Fields:**
- `name` (string): Product name
- `product_type` (string): Type of product
- `rarity` (string): Rarity level
- `category` (string): Must match existing category name

**Optional Fields:**
- `price_range` (object): Price information
- `set_number` (string): Set/card number
- `pack_count` (integer): For booster boxes/packs

### **4. Generic Array Format** (Pokemon cards, etc.)

```json
[
  {
    "id": "base1-1",
    "name": "Alakazam",
    "supertype": "Pokémon",
    "subtypes": ["Stage 2"],
    "hp": "80",
    "types": ["Psychic"],
    "set": {
      "id": "base1",
      "name": "Base Set"
    }
  }
]
```

## 🔧 Adding Your Own Data

### **1. Organize with Folders**

```bash
# Create organized folder structure
mkdir -p db/data/my_tcg_data/sets
mkdir -p db/data/my_tcg_data/cards
mkdir -p db/data/imports/bulk
mkdir -p db/data/exports/processed
```

### **2. Create JSON Files**

```bash
# Create files in organized folders
touch db/data/my_tcg_data/sets/custom_sets.json
touch db/data/imports/bulk/large_dataset.json
```

### **3. Use Any Supported Format**

```json
// Custom format
{
  "my_data_type": [
    {
      "required_field": "value",
      "optional_field": "value"
    }
  ]
}

// Array format (like Pokemon cards)
[
  {
    "id": "custom-001",
    "name": "Custom Card",
    "type": "Special"
  }
]

// TCG sets format
{
  "card_sets": [
    {
      "name": "My Custom TCG",
      "categories": [...]
    }
  ]
}
```

### **4. Load with Folder Parameters**

```ruby
# In your rake task
custom_data = DataLoaders::JsonLoader.load_data_file('custom_sets.json', 'my_tcg_data/sets')

# Load all files from folder
all_bulk_data = DataLoaders::JsonLoader.load_all_data_files('imports/bulk')
```

### **5. Use Rake Tasks with Folders**

```bash
# Validate your data
bundle exec rake db:validate_data_files[my_tcg_data/sets]

# Show what you have
bundle exec rake db:show_data_files[my_tcg_data/sets]

```

## 🚨 Data Organization Guidelines

### ✅ **Folder Best Practices**
- **Group by data source**: `pokemon-tcg-data/`, `magic-data/`, `custom/`
- **Separate by type**: `sets/`, `cards/`, `products/`
- **Use descriptive names**: `imports/`, `exports/`, `processed/`
- **Keep related files together**: All Pokemon data in one folder tree
- **Version your data**: `v1/`, `v2/`, `archive/` subfolders when needed

### ✅ **File Best Practices**
- Use consistent naming conventions
- Include all required fields for your format
- Use ISO date format (YYYY-MM-DD) when applicable
- Keep individual files reasonable (< 50MB per file)
- Use descriptive filenames (`base1.json` not `data1.json`)

### ❌ **Avoid**
- Hardcoding file paths in rake tasks (use parameters instead)
- Storing sensitive information (use ENV vars)
- Mixing different data formats in same folder
- Very deep folder nesting (max 3-4 levels)
- Invalid JSON syntax

## 🔍 **Built-in Validation System**

### **Automatic Validation**
```bash
# Validate all files in folder
bundle exec rake db:validate_data_files[pokemon-tcg-data/sets]

# Output shows:
# ✅ en.json - Valid JSON
#    📋 Keys: data, page, pageSize, count, totalCount
#    📦 Found 169 card sets
```

### **Programmatic Validation**
```ruby
# Validate TCG structure in code
errors = DataLoaders::JsonLoader.validate_tcg_structure(data)
if errors.any?
  puts "Validation errors:"
  errors.each { |error| puts "  - #{error}" }
end

# Check available folders
folders = DataLoaders::JsonLoader.available_folders
puts "Available data folders: #{folders.join(', ')}"
```

## 📊 **Current Data Statistics**

### **Pokemon TCG Data:**
- **Sets**: 169 complete sets from Base Set to current
- **Cards**: ~20,000+ individual cards across all sets
- **File Size**: ~20MB total Pokemon data
- **Format**: Official Pokemon TCG API format

### **Custom TCG Data:**
- **Card Sets**: 4 major TCG brands (Magic, Yu-Gi-Oh!, Pokemon, One Piece)
- **Categories**: 16 categories across all sets
- **Sample Products**: ~10 example products per TCG
- **File Size**: ~2KB custom data

### **Total System:**
- **Folders**: Flexible multi-level organization
- **Formats**: 4+ different JSON structures supported
- **Files**: 170+ JSON files ready to use
- **Capacity**: Tested with large datasets (50MB+)

## 🔄 **Data Management Workflow**

### **Before Adding New Data:**
1. ✅ **Organize**: Create appropriate folder structure
2. ✅ **Validate**: Check JSON syntax with validation task
3. ✅ **Test**: Run with small dataset first
4. ✅ **Backup**: Backup existing data if needed

### **Loading New Data:**
```bash
# 1. Check what's available
bundle exec rake db:show_data_files[your_folder]

# 2. Validate before loading
bundle exec rake db:validate_data_files[your_folder]

# 3. Load categories
bundle exec rake db:populate_categories_from_json

# 4. For Pokemon data specifically:
bundle exec rake db_pokemon:populate_card_sets       # Load Pokemon sets first
bundle exec rake db_pokemon:populate_cards           # Then load Pokemon cards
```

### **Managing Large Datasets:**
- ✅ **Folder organization**: Break into logical folders by TCG/type
- ✅ **File splitting**: Keep individual files under 50MB
- ✅ **Batch processing**: Use rake tasks for incremental loading
- ✅ **Progress tracking**: Rake tasks show detailed progress

## 📈 **Advanced Usage Examples**

### **Real-World Scenarios:**

```bash
# Explore Pokemon sets data
bundle exec rake db:show_data_files[pokemon-tcg-data/sets]

# Load specific Pokemon card set
bundle exec rake db:show_data_files[pokemon-tcg-data/cards/en]
# Then explore and validate files...

# Process Magic: The Gathering data
mkdir -p db/data/magic-data/sets
# Add your MTG JSON files
bundle exec rake db:validate_data_files[magic-data/sets]

# Handle bulk imports
mkdir -p db/data/imports/2024-Q4
# Add large datasets
bundle exec rake db:show_data_files[imports/2024-Q4]
```

### **Integration with External APIs:**
```ruby
# In your custom rake task
require 'data_loaders/json_loader'

# Load from multiple folders
pokemon_data = DataLoaders::JsonLoader.load_all_data_files('pokemon-tcg-data/sets')
magic_data = DataLoaders::JsonLoader.load_all_data_files('magic-data/sets')
custom_data = DataLoaders::JsonLoader.load_all_data_files('custom/imports')

# Process and combine data as needed
```

## 🎯 **Quick Start Examples**

### **For Pokemon TCG Data:**
```bash
# See what Pokemon data is available
bundle exec rake db:show_data_files[pokemon-tcg-data/sets]
bundle exec rake db:show_data_files[pokemon-tcg-data/cards/en]

# Validate Pokemon sets data
bundle exec rake db:validate_data_files[pokemon-tcg-data/sets]

# Complete Pokemon data population workflow
bundle exec rake db:populate_categories_from_json    # Creates Pokemon category
bundle exec rake db_pokemon:populate_card_sets       # Loads 169 Pokemon sets
bundle exec rake db_pokemon:populate_cards           # Loads 20,000+ Pokemon cards
```

### **For Custom TCG Data:**
```bash
# Create your structure
mkdir -p db/data/my_tcg/sets

# Add your JSON files, then:
bundle exec rake db:validate_data_files[my_tcg/sets]
bundle exec rake db:show_data_files[my_tcg/sets]
```

### **For Development:**
```bash
# Get comprehensive help
bundle exec rake db:json_data_help

# Explore available folders
cd db/data && find . -type d -name "*" | head -10
```

---

**🆘 Need Help?**
- Run `bundle exec rake db:json_data_help` for comprehensive examples
- Check `lib/tasks/populate_from_json.rake` for implementation details
- Review `lib/data_loaders/json_loader.rb` for helper methods
- All tasks support folder parameters for maximum flexibility!