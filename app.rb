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
    # Add new ingredients with quantities
    number_of_existing_ingredients = params[:existing_ingredient_count].to_i

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

    # Create new ingredients for any new inputs from the user
    number_of_new_ingredients = params[:new_ingredient_count].to_i

    number_of_new_ingredients.times do |count|
      param_number = (count + 1).to_s
      new_ingredient_name = params.fetch("ingredient_new" << param_number)
      new_ingredient = Ingredient.new(name: new_ingredient_name)
      quantity = params.fetch("quantity_new" << param_number)

      if new_ingredient.save
        Quantity.create({
          ingredient_id: new_ingredient.id,
          recipe_id: new_recipe.id,
          description: quantity
          })
      else
        @task = new_ingredient
        @page = "/recipes/#{new_recipe.id}"
        return erb(:errors)
      end
    end

    redirect("/recipes/#{new_recipe.id}")
  else
    @task = new_recipe
    @page = '/recipes/new'
    erb(:errors)
  end
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
