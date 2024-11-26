# Setup
- install bundler (installs dependencies per-project instead of globally)
  - `sudo apt install ruby-bundler`
- install dependencies
  - run `bundle config set --local path 'vendor/bundle'` to install dependencies locally instead of globally
  - `bundle install`

# Execution

On the root directory:

```bundle exec rackup```

App is exposed on localhost:9292

# Tests

```bundle exec ruby test.rb```

# Docker

```docker build -t my-ruby-app .```

```docker run --network host -d my-ruby-app```

App is exposed on localhost:9292