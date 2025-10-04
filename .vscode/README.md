# VS Code RSpec Setup

This VS Code workspace is configured to use RSpec instead of Minitest for testing.

## Extensions

The following extensions are recommended for the best RSpec experience:

- **Ruby LSP** (`shopify.ruby-lsp`) - Official Ruby language server
- **Ruby Test Explorer** (`connorshea.vscode-ruby-test-adapter`) - Run tests in the sidebar
- **Rails Run Specs** (`noku.rails-run-spec-vscode`) - Quick RSpec runners
- **Ruby Test Runner** (`mateuszdrewniak.ruby-test-runner`) - One-click test running
- **vscode-run-rspec-file** (`thadeu.vscode-run-rspec-file`) - Simple RSpec file runner
- **RSpec Snippets** (`karunamurti.rspec-snippets`) - Code snippets for RSpec
- **Go to Spec** (`lourenci.go-to-spec`) - Switch between code and spec files
- **Endwise** (`kaiwood.endwise`) - Automatically add 'end' in Ruby

## How to Run Tests

### Method 1: Command Palette
1. Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
2. Type "Tasks: Run Task"
3. Select one of:
   - **RSpec: Run current file** - Runs the current spec file
   - **RSpec: Run current line** - Runs the spec at the current cursor line
   - **RSpec: Run all specs** - Runs the entire test suite
   - **RSpec: Run with documentation format** - Runs with detailed output

### Method 2: Keyboard Shortcuts
- `Cmd+R Cmd+T` - Run current spec file
- `Cmd+R Cmd+L` - Run spec at current line
- `Cmd+R Cmd+A` - Run all specs
- `Cmd+R Cmd+D` - Run with documentation format

### Method 3: Test Explorer (if Ruby Test Explorer extension is installed)
- View tests in the Test Explorer sidebar
- Click the play button next to any test or group
- View test results inline

### Method 4: Gutter Icons (after installing extensions)
- Look for play/run icons in the left gutter next to test blocks
- Click to run individual tests or test groups

## Features

- **Test Discovery**: Automatically finds and lists all RSpec tests
- **Inline Results**: See test results directly in the editor
- **Quick Navigation**: Jump between implementation and spec files
- **Code Completion**: RSpec-specific snippets and autocompletion
- **Debugging**: Debug RSpec tests with breakpoints

## Configuration

All configuration is stored in the `.vscode/` folder:
- `settings.json` - Editor and extension settings
- `tasks.json` - Task definitions for running tests
- `keybindings.json` - Keyboard shortcuts
- `launch.json` - Debug configurations
- `extensions.json` - Recommended extensions

## Troubleshooting

If tests don't run properly:
1. Make sure you're in the correct directory (`backend/`)
2. Run `bundle install` to ensure gems are installed
3. Check that RSpec is working in terminal: `bundle exec rspec`
4. Reload VS Code window: `Cmd+Shift+P` → "Developer: Reload Window"