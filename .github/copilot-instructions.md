# GitHub Copilot Instructions - TCG Marketplace Backend

## Repository Overview

This is a **Ruby on Rails 8.0.3 API-only application** for a Trading Card Game (TCG) marketplace backend. The application uses **session-based authentication** (via authentication-zero gem), PostgreSQL database, and serves JSON API endpoints for mobile (React Native) and web (React) clients.

**Key Technologies:**
- Ruby 3.4.5, Rails 8.0.3 (API-only)
- PostgreSQL 15+ database
- RSpec testing framework with FactoryBot, Faker, Shoulda Matchers
- Authentication-zero for session-based auth (NOT JWT)
- Rubocop-rails-omakase for linting
- Brakeman for security scanning
- Overcommit for git hooks

## Critical Build & Validation Commands

**ALWAYS run commands in this exact order. These commands are validated and work correctly:**

### 1. Environment Setup (Required)
```bash
# Install dependencies - ALWAYS run this first
bundle install

# Database setup - REQUIRED before running tests or server
RAILS_ENV=development bin/rails db:create db:migrate
RAILS_ENV=test bin/rails db:create db:migrate
```

### 2. Validation Pipeline (run before committing)
```bash
# ALWAYS run all three in this order:
bundle exec rubocop              # Linting (uses GitHub format by default)
bundle exec brakeman --no-pager  # Security scan
bundle exec rspec                # Full test suite (131 tests, ~1.2 seconds)
```

### 3. Development Server
```bash
bin/rails server    # Starts on port 3000
# OR
bin/dev            # Alternative via bin/dev script
```

### 4. Testing Commands
```bash
# Run all tests (recommended)
bundle exec rspec

# Run specific test file
bundle exec rspec spec/requests/sessions_spec.rb

# Run with documentation format
bundle exec rspec --format documentation

# Reset test database if needed
RAILS_ENV=test bin/rails db:reset
```

## CI/CD Pipeline Requirements

**GitHub Actions runs these checks - ensure they pass locally:**

1. **Security Scan**: `bin/brakeman --no-pager`
2. **Linting**: `bin/rubocop -f github`
3. **Tests**: Full RSpec suite with PostgreSQL service

**Environment variables required in CI/CD:**
- `DATABASE_USERNAME=postgres`
- `DATABASE_PASSWORD=postgres`
- `DATABASE_HOST=localhost`
- `DATABASE_PORT=5432`

## Project Architecture & File Layout

### Authentication System (authentication-zero based)
- **Models**: `User`, `Session`, `Current` (for request context)
- **Controllers**: `SessionsController`, `RegistrationsController`, `PasswordsController`
- **Routes**: `POST /sign_in`, `POST /sign_up`, `DELETE /sign_out`, `GET /sessions`
- **Authentication**: HTTP Token authentication via `Authorization: Bearer <token>` header

### Core Application Structure
```
app/
├── controllers/
│   ├── application_controller.rb     # Base controller with auth logic
│   ├── sessions_controller.rb        # Sign in/out endpoints
│   ├── registrations_controller.rb   # User registration
│   └── identity/                     # Email/password management
├── models/
│   ├── user.rb                       # User model with validations
│   ├── session.rb                    # Session model for auth
│   ├── current.rb                    # Request context
│   ├── card_set.rb, category.rb, product.rb  # TCG domain models
│   └── concerns/                     # Shared model logic
└── views/                           # JSON templates (minimal)

spec/
├── models/                          # Model unit tests
├── requests/                        # API integration tests
├── factories/                       # FactoryBot factories
├── support/
│   ├── api_helpers.rb              # JSON testing helpers
│   └── shared_examples.rb          # Reusable test patterns
├── rails_helper.rb                 # Rails test config
└── spec_helper.rb                  # RSpec base config
```

### Configuration Files (Critical)
- `.rubocop.yml`: Uses rubocop-rails-omakase + GitHub formatter by default
- `.overcommit.yml`: Pre-commit hooks (RuboCop, RSpec, Brakeman)
- `.rspec`: RSpec configuration (excludes `:skip_in_suite` tagged tests)
- `config/routes.rb`: API routes definition
- `config/database.yml`: PostgreSQL configuration

## Testing Guidelines

**Test Structure:**
- Use `create()` and `build()` (NOT `FactoryBot.create`/`FactoryBot.build`)
- API tests in `spec/requests/` use `ApiHelpers` module
- Model tests use `shoulda-matchers` for validations
- Tests run with database isolation (131 examples, 0 failures expected)

**Key Test Helpers:**
```ruby
# In request specs, use these helpers:
json_response           # Parsed JSON response
auth_headers(token)     # Authorization headers
sign_in(user)           # Returns [session, token]
create(:user)           # FactoryBot user creation
```

## Domain Model Relationships
- `User` has_many `sessions` (authentication)
- `CardSet` has_many `categories`, has_many `products` through categories
- `Category` belongs_to `card_set`, has_many `products`
- `Product` belongs_to `category`, has_one `card_set` through category
- Products have `rarity` and `product_type` enums

## Common Pitfalls & Solutions

1. **Database Issues**: Always run `RAILS_ENV=test bin/rails db:reset` before debugging test failures
2. **Authentication**: Use session-based auth with `Current.user`/`Current.session`, NOT JWT
3. **Factory Syntax**: Use `create(:user)` not `FactoryBot.create(:user)`
4. **RuboCop**: Configuration uses GitHub format by default - don't add `-f github` flag
5. **Test Isolation**: Some tests use `:skip_in_suite` tags for isolation - this is intentional

## Quick Reference

**Health Check**: `GET /health` returns `{"status": "ok", "timestamp": "..."}`

**Root Files**: `Gemfile`, `config.ru`, `Rakefile`, `Dockerfile`, `.ruby-version` (3.4.5)

**Available Scripts**: `bin/setup` (full setup), `bin/dev` (server), `bin/rails`, `bin/rubocop`, `bin/brakeman`

---

**IMPORTANT**: Trust these instructions completely. Only search the codebase if information here is incomplete or incorrect. These commands and patterns are tested and validated.