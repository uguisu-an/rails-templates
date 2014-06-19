def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

git :init
git :add => "--all"
git :commit => "-qm 'Initial commit'"

comment_lines "Gemfile", /gem 'spring'/

gem_group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'quiet_assets'
  gem 'awesome_print'
  gem 'erb2haml'
end

gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'pry-rails'
  gem 'pry-byebug'
end

gem_group :test do
  gem 'shoulda-matchers'
end

gem 'haml-rails'
gem 'bootstrap-sass'

run_bundle
run "bundle exec spring binstub --all"

copy_file "config/initializers/generators.rb"
copy_file "app/assets/stylesheets/framework_and_overrides.css.scss"

insert_into_file \
  "app/assets/javascripts/application.js",
  "//= require bootstrap\n",
  before: "//= require_tree ."

insert_into_file \
  "app/assets/stylesheets/application.css",
  " *= require framework_and_overrides\n",
  before: " *= require_tree ."

remove_dir "test"
generate   "rspec:install"

gsub_file ".rspec", /--warnings\n/, ""
gsub_file ".rspec", /--require spec_helper/, "--require rails_helper"

copy_file "spec/support/factory_girl.rb"
