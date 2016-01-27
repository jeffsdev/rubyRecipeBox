require('bundler/setup')
require "pry"
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


get('/') do
  erb(:index)
end

post('/recipes') do
  new_recipe = Recipe.new(name: params[:recipe_name])

  if new_recipe.save

    # Add any ingredients with existing records to the recipe
    existing_ingredients = params[:ingredient_ids].to_a
    if existing_ingredients.any?
      existing_ingredients.each do |ingredient_id|
        new_recipe.ingredients << Ingredient.find(ingredient_id.to_i)
      end
    end

    # Create new ingredients for any new inputs from the user
    params[:ingredient_count].to_i.times do |count|
      ingredient_number = "ingredient" << (count + 1).to_s
      new_ingredient_name = params.fetch(ingredient_number)
      new_ingredient = Ingredient.new(name: new_ingredient_name)

      if new_ingredient.save
        new_recipe.ingredients << new_ingredient
        redirect("/recipes/#{new_recipe.id}")
      else
        @task = new_ingredient
        @page = "/recipes/#{new_recipe.id}"
        return erb(:errors)
      end
    end
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
  @ingredients = @recipe.ingredients
  erb(:recipe)
end
