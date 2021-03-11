# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_gopay_integration/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_gopay_integration'
  s.version     = SpreeGopayIntegration.version
  s.summary     = 'Spree integration with GoPay.'
  s.description = 'Spree integration with GoPay payment gateway.'
  s.required_ruby_version = '>= 2.2.2'

  s.author    = 'Josef Hovad'
  s.email     = 'josef.hovad@nobord.com'
  s.homepage  = 'https://github.com/nobord/spree_gopay_integration'
  s.license = 'BSD-3-Clause'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 4.2', '< 5.0'
  s.add_dependency 'spree_frontend', '~> 4.2'
  s.add_dependency 'gopay-ruby', '~> 0.2.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'mysql2'
  s.add_development_dependency 'appraisal'
end
