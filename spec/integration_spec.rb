require 'spec_helper'

feature "Adding a recipe", :js => true do
  scenario "allows the user to add a recipe" do
    existing_ingredient = Ingredient.create(name: 'existing ingredient')
    visit('/')
    click_link 'Add a New Recipe'
    fill_in 'recipe_name', with: 'Test Recipe'
    check 'existing ingredient'
    click_button('add-ingredient')
    fill_in 'ingredient1', with: 'new ingredient'
    click_button 'Create'
    expect(page).to have_content('Test Recipe')
    expect(page).to have_content('existing ingredient')
    expect(page).to have_content('new ingredient')
  end
end
