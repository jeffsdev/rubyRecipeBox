require 'spec_helper'

feature "Adding a recipe" do
  scenario "allows the user to add a recipe" do
    visit('/')
    click_link 'Add a New Recipe'
    fill_in 'recipe_name', with: 'Test Recipe'
    click_button 'Create'
    expect(page).to have_content('Test Recipe')
  end
end
