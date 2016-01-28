require('bundler/setup')
require "pry"
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


get('/') do
  recipes_rated = Recipe.where('rating IS NOT NULL').order(rating: :desc).order(:name)
  recipes_no_rating = Recipe.where('rating IS NULL').order(:name)
  @recipes = recipes_rated + recipes_no_rating
  @ingredients = Ingredient.order(:name)
  @tags = Tag.order(:name)
  erb(:index)
end

post('/recipes') do
  new_recipe = Recipe.new({
    name: params[:recipe_name],
    instructions: params[:instructions],
    rating: params[:rating]
    })

  unless new_recipe.save
    @task = new_recipe
    @page = '/recipes/new'
    return erb(:errors)
  end

  # Add ingredients
  add_existing_ingredients(new_recipe, params)
  add_new_ingredients(new_recipe, params)

  # Add recipe tags
  tag_string = params[:tags]
  new_recipe.tag_string_to_tags(tag_string)

  redirect("/recipes/#{new_recipe.id}")
end

get('/recipes/new') do
  @ingredients = Ingredient.order(:name)
  erb(:recipe_form)
end

get('/recipes/:id') do
  @recipe = Recipe.find(params[:id])
  @tags = @recipe.tags
  @quantities = @recipe.quantities
  @instructions = @recipe.instructions
  @rating = @recipe.rating
  erb(:recipe)
end

patch('/recipes/:id') do
  id = params[:id]
  recipe = Recipe.find(id)

  # Update name, instructions, rating
  recipe.update({
    name: params[:recipe_name],
    instructions: params[:instructions],
    rating: params[:rating]
    })

  # Update ingredients
  recipe.ingredients.delete_all
  add_existing_ingredients(recipe, params)
  add_new_ingredients(recipe, params)

  # Update tags
  tag_string = params[:tags]
  recipe.tags.delete_all
  recipe.tag_string_to_tags(tag_string)

  redirect("/recipes/#{id}")
end

get('/recipes/:id/edit') do
  @ingredients = Ingredient.order(:name)
  @recipe = Recipe.find(params[:id])
  @quantities = @recipe.quantities
  @instructions = @recipe.instructions
  @rating = @recipe.rating

  tag_objects = @recipe.tags
  @tags = []
  tag_objects.each() do |tag|
    @tags << tag.name
  end
  @tags = @tags.join(', ')

  erb(:recipe_update_form)
end

get('/ingredients/:id') do
  @ingredient = Ingredient.find(params[:id])
  @recipes = @ingredient.recipes
  erb(:ingredient)
end

get('/tags/:id') do
  @tag = Tag.find(params[:id])
  @recipes = @tag.recipes
  erb(:tag)
end

helpers do
  def add_existing_ingredients(recipe, params)
    number_of_ingredients = params[:existing_ingredient_count].to_i
    if number_of_ingredients > 0
      number_of_ingredients.times do |count|
        param_number = (count + 1).to_s
        existing_ingredient_id = params.fetch("ingredient_existing" << param_number)
        quantity = params.fetch("quantity_existing" << param_number)

        Quantity.create({
          ingredient_id: existing_ingredient_id,
          recipe_id: recipe.id,
          description: quantity
          })
      end
    end
  end

  def add_new_ingredients(recipe, params)
    number_of_ingredients = params[:new_ingredient_count].to_i

    number_of_ingredients.times do |count|
      param_number = (count + 1).to_s
      new_ingredient_name = params.fetch("ingredient_new" << param_number)
      quantity = params.fetch("quantity_new" << param_number)

      existing_ingredient_match = Ingredient.find_by(name: new_ingredient_name)
      if existing_ingredient_match.nil?
        new_ingredient = Ingredient.create(name: new_ingredient_name)
      else
        new_ingredient = existing_ingredient_match
      end

      unless new_ingredient.id.nil?
        Quantity.create({
          ingredient_id: new_ingredient.id,
          recipe_id: recipe.id,
          description: quantity
          })
      end
    end
  end
end
