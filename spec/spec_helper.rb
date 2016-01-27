ENV['RACK_ENV'] = 'test'

require('bundler/setup')
Bundler.require(:default, :test)
set(:root, Dir.pwd())

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

require('capybara/rspec')
Capybara.app = Sinatra::Application
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
  Recipe.create({name: "Test Recipe"})
end

def create_test_ingredient
  Ingredient.create({name: "test ingredient"})
end

def create_test_tag
  Tag.create({name: "test tag"})
end
