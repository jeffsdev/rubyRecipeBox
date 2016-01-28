require('bundler/setup')
require "pry"
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


get('/') do
  erb(:index)
end

post('/recipes') do
  new_recipe = Recipe.new({
    name: params[:recipe_name],
    instructions: params[:instructions]
    })

  if new_recipe.save

  else
    @task = new_recipe
    @page = '/recipes/new'
    return erb(:errors)
  end

  # Add new ingredients with quantities
  number_of_existing_ingredients = params[:existing_ingredient_count].to_i

  if number_of_existing_ingredients > 0
    number_of_existing_ingredients.times do |count|
      param_number = (count + 1).to_s
      existing_ingredient_id = params.fetch("ingredient_existing" << param_number)
      quantity = params.fetch("quantity_existing" << param_number)

      Quantity.create({
        ingredient_id: existing_ingredient_id,
        recipe_id: new_recipe.id,
        description: quantity
        })
    end
  end

  # Create new ingredients for any new inputs from the user
  number_of_new_ingredients = params[:new_ingredient_count].to_i

  number_of_new_ingredients.times do |count|
    param_number = (count + 1).to_s
    new_ingredient_name = params.fetch("ingredient_new" << param_number)
    quantity = params.fetch("quantity_new" << param_number)

    existing_ingredient_match = Ingredient.find_by(name: new_ingredient_name)
    if existing_ingredient_match.nil?
      new_ingredient = Ingredient.new(name: new_ingredient_name)
      new_ingredient.save
    else
      new_ingredient = existing_ingredient_match
    end

    unless new_ingredient.id.nil?
      Quantity.create({
        ingredient_id: new_ingredient.id,
        recipe_id: new_recipe.id,
        description: quantity
        })
    end
  end

  # Add recipe tags

  redirect("/recipes/#{new_recipe.id}")
end

get('/recipes/new') do
  @ingredients = Ingredient.all
  erb(:recipe_form)
end

get('/recipes/:id') do
  @recipe = Recipe.find(params[:id])
  @quantities = @recipe.quantities
  @instructions = @recipe.instructions
  erb(:recipe)
end
