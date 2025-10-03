# TCG Marketplace - Backend API

A Ruby on Rails API-only application for a Trading Card Game (TCG) marketplace. This backend serves as the foundation for both mobile (React Native) and web (React) clients.

## 🚀 Tech Stack

- **Ruby**: 3.4.5
- **Rails**: 8.0.3 (API-only mode)
- **Database**: PostgreSQL 15
- **Testing**: RSpec with FactoryBot, Faker, and Shoulda Matchers
- **JSON Serialization**: Jbuilder
- **Web Server**: Puma
- **CORS**: Rack-CORS for cross-origin requests

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Ruby 3.4.5 (recommended via rbenv)
- PostgreSQL 15+
- Bundler gem
- Git

## 🛠️ Installation & Setup

### 1. Clone the repository
```bash
git clone https://github.com/roseliux/tcg_seller_backend.git
cd tcg_seller_backend
```

### 2. Install Ruby dependencies
```bash
bundle install
```

### 3. Database setup
```bash
# Create the databases
rails db:create

# Run migrations (when available)
rails db:migrate

# Seed the database (optional)
rails db:seed
```

### 4. Start the development server
```bash
rails server
```

The API will be available at `http://localhost:3000`

## 🗄️ Database Configuration

This application uses PostgreSQL with the following database names:
- **Development**: `tcg_seller_development`
- **Test**: `tcg_seller_test`
- **Production**: `tcg_seller_production` (with cache, queue, and cable databases)

### Environment Variables

You can configure database connection using these environment variables:
- `DATABASE_USERNAME`: Database user (defaults to system user)
- `DATABASE_PASSWORD`: Database password
- `DATABASE_HOST`: Database host (defaults to localhost)
- `DATABASE_PORT`: Database port (defaults to 5432)

## 🧪 Testing

This project uses **RSpec** as the testing framework with additional testing gems for comprehensive API testing.

### Testing Stack
- **RSpec Rails**: Core testing framework
- **FactoryBot**: Object generation for tests
- **Faker**: Realistic fake data generation
- **Shoulda Matchers**: Rails-specific matchers
- **JSON Matchers**: JSON response testing
- **Database Cleaner**: Clean database state between tests

### Running Tests

```bash
# Run all specs
bundle exec rspec

# Run with documentation format (verbose)
bundle exec rspec --format documentation

# Run specific spec file
bundle exec rspec spec/requests/application_spec.rb

# Run specific test by line number
bundle exec rspec spec/requests/application_spec.rb:10

# Run only request specs
bundle exec rspec spec/requests/

# Run only model specs
bundle exec rspec spec/models/

# Run with coverage (if configured)
COVERAGE=true bundle exec rspec
```

### Testing Patterns

#### Request Specs (API Testing)
```ruby
# spec/requests/cards_spec.rb
RSpec.describe 'Cards API', type: :request do
  describe 'GET /cards' do
    before { get '/cards' }

    it_behaves_like 'returns successful response'

    it 'returns list of cards' do
      expect(json_response).to be_an(Array)
    end
  end

  describe 'POST /cards' do
    let(:valid_params) { { name: 'Test Card', price: 10.99 } }

    context 'with valid parameters' do
      before { post_json '/cards', valid_params }

      it_behaves_like 'returns successful response', :created
    end
  end
end
```

#### Model Specs
```ruby
# spec/models/card_spec.rb
RSpec.describe Card, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_numericality_of(:price) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
```

#### Using Factories
```ruby
# spec/factories/cards.rb
FactoryBot.define do
  factory :card do
    name { Faker::Games::Pokemon.name }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end

# In specs
let(:card) { create(:card) }
let(:cards) { create_list(:card, 3) }
```

### API Testing Helpers

The project includes custom helpers for API testing:

```ruby
# Available in request specs
json_response          # Parsed JSON response
post_json(path, data)  # POST with JSON headers
put_json(path, data)   # PUT with JSON headers
expect_successful_json_response(status) # Assert success with JSON
```

### Shared Examples

```ruby
# Use shared examples for common patterns
it_behaves_like 'an API endpoint'
it_behaves_like 'returns successful response'
it_behaves_like 'returns error response', :not_found
it_behaves_like 'validates required parameters', [:name, :price]
```

## 📡 API Endpoints

The API uses JSON format for all requests and responses. CORS is configured to allow cross-origin requests for mobile and web clients.

### Health Check
```bash
GET /health
```

Returns application health status:
```json
{
  "status": "ok",
  "timestamp": "2025-10-02T22:30:00Z"
}
```


## 🚢 Deployment

This application is configured for deployment with Kamal. The Docker configuration and deployment settings are included.

### Docker
The application includes a `Dockerfile` for containerized deployment.

### Production Environment
Ensure the following environment variables are set in production:
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `DATABASE_HOST`
- `DATABASE_PORT`
- `RAILS_MASTER_KEY` (for credentials)

## 🔧 Development

### Code Quality & Pre-commit Hooks

This project uses **Overcommit** for automated code quality checks:

#### Pre-commit Hooks (run automatically on `git commit`):
- **RuboCop**: Ruby style guide enforcement (Rails Omakase configuration)
- **RSpec**: Fast test suite to catch breaking changes
- **Brakeman**: Security vulnerability scanning

#### Pre-push Hooks (run automatically on `git push`):
- **RSpec**: Full test suite

#### Manual Commands:
```bash
# Run code quality checks manually
bundle exec rubocop -f github              # Style check
bundle exec rubocop -A                     # Auto-fix issues
bundle exec rspec                          # Run tests
bundle exec brakeman --no-pager            # Security scan

# Skip hooks if needed (emergency use only)
git commit --no-verify -m "Emergency fix"
git push --no-verify
```

### Debugging
The `debug` gem is available in development and test environments for debugging.

## 📁 Project Structure

```
app/
├── controllers/          # API controllers
├── models/              # Active Record models
├── views/               # Jbuilder JSON templates
└── jobs/                # Background jobs

config/
├── routes.rb            # API routes
├── database.yml         # Database configuration
└── initializers/
    └── cors.rb          # CORS configuration

db/
├── migrate/             # Database migrations
└── seeds.rb            # Database seeds

spec/                    # RSpec test files
├── factories/           # FactoryBot factories
├── models/              # Model specs
├── requests/            # API request specs (integration tests)
├── support/             # Test helpers and shared examples
│   ├── api_helpers.rb   # JSON API testing helpers
│   └── shared_examples.rb # Reusable test patterns
├── rails_helper.rb      # Rails-specific test configuration
└── spec_helper.rb       # General RSpec configuration

.overcommit.yml          # Git hooks configuration
.rspec                   # RSpec configuration
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is private and proprietary.

## 🎯 Roadmap

- [ ] User authentication (JWT)
- [ ] Card management API
- [ ] Listing management API
- [ ] User profiles
- [ ] Search and filtering
- [ ] Image upload support
- [ ] Payment integration
- [ ] Real-time notifications

## 📞 Support

For questions or support, please open an issue in the repository.
