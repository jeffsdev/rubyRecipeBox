ENV['RACK_ENV'] = 'test'

require('bundler/setup')
Bundler.require(:default, :test)
set(:root, Dir.pwd())

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

require('capybara/rspec')
Capybara.app = Sinatra::Application
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.javascript_driver = :chrome
Capybara.current_driver = Capybara.javascript_driver
set(:show_exceptions, false)
require('./app')

RSpec.configure do |config|
  config.after(:each) do
    Recipe.all().each() do |recipe|
      recipe.destroy()
    end
    Ingredient.all().each() do |ingredient|
      ingredient.destroy()
    end
    Tag.all().each() do |tag|
      tag.destroy()
    end
  end
end

def create_test_recipe
  Recipe.create({name: "test recipe"})
end

def create_test_ingredient
  Ingredient.create({name: "test ingredient"})
end

def create_test_tag
  Tag.create({name: "test tag"})
end
