module DataLoaders
  class JsonLoader
    class << self
      # Load JSON data from db/data directory or subdirectory
      def load_data_file(filename, folder = nil)
        if folder
          file_path = Rails.root.join("db", "data", folder, filename)
        else
          file_path = Rails.root.join("db", "data", filename)
        end

        unless File.exist?(file_path)
          raise "JSON file not found: #{file_path}"
        end

        begin
          JSON.parse(File.read(file_path))
        rescue JSON::ParserError => e
          raise "Invalid JSON in #{filename}: #{e.message}"
        end
      end

      # Load all JSON files from db/data directory or subdirectory
      def load_all_data_files(folder = nil)
        if folder
          data_dir = Rails.root.join("db", "data", folder)
        else
          data_dir = Rails.root.join("db", "data")
        end

        return {} unless Dir.exist?(data_dir)

        json_files = Dir[data_dir.join("*.json")]
        loaded_data = {}

        json_files.each do |file_path|
          filename = File.basename(file_path, ".json")
          begin
            loaded_data[filename] = JSON.parse(File.read(file_path))
          rescue JSON::ParserError => e
            Rails.logger.warn "Skipping invalid JSON file #{filename}: #{e.message}"
          end
        end

        loaded_data
      end

      # Get available data files
      def available_files(folder = nil)
        if folder
          data_dir = Rails.root.join("db", "data", folder)
        else
          data_dir = Rails.root.join("db", "data")
        end

        return [] unless Dir.exist?(data_dir)

        Dir[data_dir.join("*.json")].map { |f| File.basename(f) }
      end

      # Get available subdirectories in db/data
      def available_folders
        data_dir = Rails.root.join("db", "data")
        return [] unless Dir.exist?(data_dir)

        Dir[data_dir.join("*/")].map { |d| File.basename(d) }.sort
      end

      # Validate JSON structure for TCG data
      def validate_tcg_structure(data)
        errors = []

        # Check for required top-level keys
        unless data.is_a?(Hash)
          errors << "Data must be a Hash/Object"
          return errors
        end

        # Validate card_sets structure
        if data["card_sets"]
          unless data["card_sets"].is_a?(Array)
            errors << "'card_sets' must be an array"
          else
            data["card_sets"].each_with_index do |set, index|
              errors.concat(validate_card_set(set, index))
            end
          end
        end

        errors
      end

      private

      def validate_card_set(set, index)
        errors = []
        prefix = "card_sets[#{index}]"

        unless set.is_a?(Hash)
          errors << "#{prefix} must be an object"
          return errors
        end

        # Required fields
        errors << "#{prefix}.name is required" unless set["name"].present?

        # Categories validation
        if set["categories"]
          unless set["categories"].is_a?(Array)
            errors << "#{prefix}.categories must be an array"
          else
            set["categories"].each_with_index do |category, cat_index|
              errors.concat(validate_category(category, "#{prefix}.categories[#{cat_index}]"))
            end
          end
        end

        errors
      end

      def validate_category(category, prefix)
        errors = []

        unless category.is_a?(Hash)
          errors << "#{prefix} must be an object"
          return errors
        end

        errors << "#{prefix}.name is required" unless category["name"].present?

        if category["release_date"].present?
          begin
            Date.parse(category["release_date"])
          rescue ArgumentError
            errors << "#{prefix}.release_date must be a valid date"
          end
        end

        errors
      end
    end
  end
end
