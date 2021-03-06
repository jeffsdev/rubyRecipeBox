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
    fill_in 'instructions', with: '1. Test instructionify.'
    fill_in 'tags', with: 'test tag, testfast'
    select '5 stars'
    click_button 'Create'
    expect(page).to have_content('Test Recipe')
    expect(page).to have_content('1 tsp existing ingredient')
    expect(page).to have_content('1 Tb new ingredient')
    expect(page).to have_content('1. Test instructionify.')
    expect(page).to have_content('test tag')
    expect(page).to have_content('testfast')
    expect(page.has_css?('glyphicon-star', count: 5))
  end
end

feature "Editing a recipe", :js => true do
  background do
    recipe = Recipe.create({
      name: 'Test Recipe',
      instructions: '1. Test instructionify.',
      rating: 5
      })
    recipe.tags.create(name: 'test tag')
    ingredient = recipe.ingredients.create(name: 'existing ingredient')
    Quantity.create({
      ingredient_id: ingredient.id,
      recipe_id: recipe.id,
      description: "1 tsp"
      })
  end

  scenario "allows the user to edit an existing recipe" do
    visit('/')
    click_link('Test Recipe')
    click_link('Edit')
    fill_in 'recipe_name', with: 'New Recipe Name'
    fill_in 'instructions', with: '1. New instruction.'
    select '3 stars'
    fill_in 'tags', with: 'new tag, testfast'
    fill_in 'quantity_existing1', with: '2 tsp'
    click_button('add-new-ingredient')
    fill_in 'quantity_new1', with: '1 Tb'
    fill_in 'ingredient_new1', with: 'new ingredient'
    click_button('Update')
    expect(page).to have_content('New Recipe Name')
    expect(page).to have_content('2 tsp existing ingredient')
    expect(page).to have_content('1 Tb new ingredient')
    expect(page).to have_content('1. New instruction.')
    expect(page).to have_content('new tag')
    expect(page).to have_content('testfast')
    expect(page.has_css?('glyphicon-star', count: 3))
  end
end
