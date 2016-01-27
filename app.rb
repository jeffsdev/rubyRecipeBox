require('bundler/setup')
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }


get('/') do
  erb(:index)
end

post('/recipes') do
  new_recipe = Recipe.new(name: params[:recipe_name])

  if new_recipe.save
    redirect("/recipes/#{new_recipe.id}")
  else
    @task = new_recipe
    @page = '/recipes/new'
    erb(:errors)
  end
end

get('/recipes/new') do
  erb(:recipe_form)
end

get('/recipes/:id') do
  @recipe = Recipe.find(params[:id])
  erb(:recipe)
end
