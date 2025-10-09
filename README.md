# TCG Marketplace - Backend API

A Ruby on Rails API-only application for a Trading Card Game (TCG) marketplace. This backend serves as the foundation for both mobile (React Native) and web (React) clients with complete session-based authentication.

## 🎉 **Project Status: Authentication Complete!**

✅ **Complete session-based authentication system with authentication-zero**
✅ **Mobile app integration with CORS and session tokens**
✅ **Test user database seeding for development**
✅ **RSpec testing framework with 131 passing tests**
✅ **Network-accessible server for device testing**

## 🚀 Tech Stack

### **Core Framework**
- **Ruby**: 3.4.5
- **Rails**: 8.0.3 (API-only mode)
- **Database**: PostgreSQL 15+
- **Web Server**: Puma (configured for network access)

### **Authentication & Security**
- **Authentication-zero**: Session-based authentication (NOT JWT)
- **CORS**: Rack-CORS configured for mobile app integration
- **Session Tokens**: Custom `X-Session-Token` header for mobile clients
- **Brakeman**: Security vulnerability scanning

### **Testing & Quality**
- **RSpec**: Main testing framework with 131 passing tests
- **FactoryBot**: Test data generation
- **Faker**: Realistic fake data
- **Shoulda Matchers**: Rails-specific test matchers
- **RuboCop**: Code style enforcement with Rails Omakase config
- **Overcommit**: Pre-commit hooks for quality assurance

### **JSON & Serialization**
- **Jbuilder**: JSON template engine for API responses

## � Documentation

Additional detailed documentation is available in the `docs/` folder:

- **[JSON Data Management System](docs/README_JSON_LOADER.md)**: Comprehensive guide for managing TCG data with JSON files, including Pokemon TCG API integration, flexible folder structures, and parameterized rake tasks

## �📋 Prerequisites

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
# Create and setup databases for both development and test
RAILS_ENV=development bin/rails db:create db:migrate
RAILS_ENV=test bin/rails db:create db:migrate

# Seed the database with test users (REQUIRED for mobile app testing)
bin/rails db:seed

# Populate categories
bundle exec rake db:populate_categories_from_json

# Pokemon-specific population tasks
bundle exec rake db_pokemon:populate_card_sets    # Populate Pokemon card sets
bundle exec rake db_pokemon:populate_cards        # Populate Pokemon 19k cards
```

**Test Users Created:**
- **John Doe**: `john@example.com` / `password123456`
- **Jane Smith**: `jane@example.com` / `password123456`

### 4. Start the development server
```bash
# For network access (required for mobile device testing)
bin/rails server -b 0.0.0.0

# Or use the standard localhost-only server
bin/rails server
```

**Server Access:**
- **Local**: `http://localhost:3000`
- **Network** (for mobile): `http://192.168.68.115:3000` (or your network IP)
- **Health Check**: `GET /health` returns `{"status": "ok", "timestamp": "..."}`

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
# Run all specs (recommended - 131 tests, ~1.2 seconds)
bundle exec rspec

# Run with documentation format (verbose)
bundle exec rspec --format documentation

# Run specific spec file
bundle exec rspec spec/requests/sessions_spec.rb

# Run specific test by line number
bundle exec rspec spec/requests/sessions_spec.rb:10

# Reset test database if needed
RAILS_ENV=test bin/rails db:reset
```

### **Test Coverage**
- **131 passing tests** (100% success rate)
- **Authentication system**: Complete session management testing
- **API endpoints**: Full request/response validation
- **Model validations**: User, Session, and domain models
- **Security**: Authentication and authorization flows

## 📡 API Endpoints

The API uses JSON format for all requests and responses. CORS is configured to allow cross-origin requests for mobile and web clients with custom header support.

### 🔐 Authentication Endpoints (IMPLEMENTED)

#### **Sign In**
```bash
POST /sign_in
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123456"
}
```

**Response:**
```json
{
  "id": "session_id_here"
}
```
**Headers:** `X-Session-Token: your_session_token_here`

#### **Sign Up**
```bash
POST /sign_up
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "password123456",
  "first_name": "New",
  "last_name": "User",
  "user_name": "newuser"
}
```

#### **Sign Out**
```bash
DELETE /sign_out
Authorization: Bearer your_session_token_here
```

#### **Current User**
```bash
GET /me
Authorization: Bearer your_session_token_here
```

**Response:**
```json
{
  "id": 1,
  "email": "john@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "user_name": "johndoe",
  "verified": true,
  "created_at": "2025-01-01T00:00:00.000Z",
  "updated_at": "2025-01-01T00:00:00.000Z"
}
```

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

### **Mobile App Integration**
For mobile app connectivity:
- **CORS Origins**: Configure allowed origins in `config/initializers/cors.rb`
- **Network Binding**: Use `rails server -b 0.0.0.0` for device testing
- **Session Headers**: `X-Session-Token` header exposed for authentication

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
├── controllers/
│   ├── application_controller.rb     # Base controller with auth logic ✅
│   ├── sessions_controller.rb        # Authentication endpoints ✅
│   ├── registrations_controller.rb   # User registration ✅
│   ├── passwords_controller.rb       # Password management ✅
│   └── identity/                     # Email/password identity management
├── models/
│   ├── user.rb                       # User model with validations ✅
│   ├── session.rb                    # Session model for auth ✅
│   ├── current.rb                    # Request context helper ✅
│   ├── card_set.rb, category.rb, product.rb  # TCG domain models ✅
│   └── concerns/                     # Shared model logic
├── views/                           # Jbuilder JSON templates
└── jobs/                            # Background jobs

config/
├── routes.rb                        # API routes with auth endpoints ✅
├── database.yml                     # PostgreSQL configuration ✅
└── initializers/
    └── cors.rb                      # CORS with mobile app support ✅

db/
├── migrate/                         # Database migrations ✅
└── seeds.rb                        # Test user seeds ✅

spec/                               # RSpec test files (131 tests) ✅
├── factories/                      # FactoryBot factories ✅
├── models/                         # Model unit tests ✅
├── requests/                       # API integration tests ✅
├── support/
│   ├── api_helpers.rb             # JSON API testing helpers ✅
│   └── shared_examples.rb         # Reusable test patterns ✅
├── rails_helper.rb                # Rails test configuration ✅
└── spec_helper.rb                 # RSpec configuration ✅

.overcommit.yml                     # Pre-commit hooks ✅
.rspec                             # RSpec configuration ✅
.rubocop.yml                       # Code style configuration ✅
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

### **Completed** ✅
- **User authentication** (session-based with authentication-zero)
- **User registration and sign-in/sign-out**
- **Mobile app API integration**
- **CORS configuration for cross-origin requests**
- **Test user database seeding**
- **Complete RSpec testing suite**
- **Code quality and security scanning**

### **Coming Soon** 🚧
- Card management API (CRUD operations)
- Listing management API
- Enhanced user profiles
- Search and filtering endpoints
- Image upload support
- Payment integration
- Real-time notifications
- API rate limiting and caching

## 🔐 **Authentication Usage**

### **Mobile App Integration**
```bash
# Sign in and get session token
curl -X POST http://192.168.68.115:3000/sign_in \
  -H "Content-Type: application/json" \
  -d '{"email": "john@example.com", "password": "password123456"}'

# Use session token in subsequent requests
curl -X GET http://192.168.68.115:3000/me \
  -H "Authorization: Bearer YOUR_SESSION_TOKEN"
```

### **Session Management**
- **Session Creation**: POST `/sign_in` returns session token in `X-Session-Token` header
- **Token Usage**: Include `Authorization: Bearer <token>` header in authenticated requests
- **Session Cleanup**: DELETE `/sign_out` properly destroys session
- **Current User**: GET `/me` returns authenticated user data
