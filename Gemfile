# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

gem 'activerecord-session_store'
gem 'chamber', '~> 2.10.1'

gem 'decidim', git: 'https://github.com/demonodojo/decidim.git', branch: 'bugfixing'
gem 'decidim-consultations', git: 'https://github.com/demonodojo/decidim.git', branch: 'bugfixing'
gem 'decidim-direct_verifications', '0.17.8'
gem 'omniauth-saml'

gem 'bootsnap', '~> 1.3'

gem 'puma', '~> 3.0'
gem 'uglifier', '~> 4.1'

gem 'faker', '~> 1.9'

gem 'httplog'

group :development, :test do
  gem 'byebug', '~> 10.0', platform: :mri

  #gem 'decidim-dev', '~> 0.17.1'
end

group :development do
  gem 'airbrussh', require: false
  gem 'capistrano', '3.3.5'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
