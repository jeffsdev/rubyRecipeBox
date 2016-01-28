require 'spec_helper'

feature "Finding recipes" do
  background do
    recipe = Recipe.create(name: 'Existing Recipe')
    recipe.ingredients.create(name: 'existing ingredient')
  end

  scenario "allows the user to find a recipe by ingredient" do
    visit('/')
    click_link('existing ingredient')
    expect(page).to have_content('Existing Recipe')
  end
end
