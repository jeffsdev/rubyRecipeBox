require 'spec_helper'

feature "Adding a recipe", :js => true do
  scenario "allows the user to add a recipe" do
    existing_ingredient = Ingredient.create(name: 'existing ingredient')
    visit('/')
    click_link 'Add a New Recipe'
    fill_in 'recipe_name', with: 'Test Recipe'
    select 'existing ingredient'
    click_button('add-new-ingredient')
    fill_in 'quantity_existing1', with: '1 tsp'
    fill_in 'ingredient_new1', with: 'new ingredient'
    fill_in 'quantity_new1', with: '1 Tb'
    click_button 'Create'
    expect(page).to have_content('Test Recipe')
    expect(page).to have_content('1 tsp existing ingredient')
    expect(page).to have_content('1 Tb new ingredient')
  end
end
