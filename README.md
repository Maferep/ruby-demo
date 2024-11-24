# Setup
- install bundler (installs dependencies per-project instead of globally)
  - `sudo apt install ruby-bundler`
- install dependencies
  - run `bundle config set --local path 'vendor/bundle'` to install dependencies locally insteal of globally
  - `bundle install`

# Execution

On the root directory:

```bundle exec rackup```

# Tests

```bundle exec ruby test.rb```