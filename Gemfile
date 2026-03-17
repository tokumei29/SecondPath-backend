source "https://rubygems.org"

gem "rails", "8.1.2"
gem "pg"
gem "puma", ">= 5.0"

gem "rack-cors"
gem "dotenv-rails"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

gem "rubocop", require: false
gem "rubocop-rails", require: false
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false

  gem "rspec-rails", "~> 7.0"
  gem "factory_bot_rails"
  gem "faker"
end
gem "jwt", "~> 3.1"
