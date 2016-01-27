require "spec_helper"

describe(Ingredient) do
  it('validates the presence of the name') do
    test_ingredient = Ingredient.new(name: "")
    expect(test_ingredient.save).to(eq(false))
  end

  it('validates the uniqueness of the name of the ingredient') do
    test_ingredient = create_test_ingredient
    second_ingredient_with_same_name = Ingredient.new({name: "test ingredient"})
    third_ingredient_with_same_name_capitalized = Ingredient.new({name: "Test Ingredient"})
    expect(second_ingredient_with_same_name.save).to(eq(false))
    expect(third_ingredient_with_same_name_capitalized.save).to(eq(false))
  end

  describe('#recipes') do
    it('returns a list of recipes that use the ingredient') do
      test_recipe = create_test_recipe()
      test_ingredient = test_recipe.ingredients.create({
        name: "test ingredient"
        })
      expect(test_ingredient.recipes).to(eq([test_recipe]))
    end
  end
end
