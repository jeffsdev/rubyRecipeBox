require "spec_helper"

describe(Recipe) do
  it('validates the presence of the name') do
    test_recipe = Recipe.new(name: "")
    expect(test_recipe.save).to(eq(false))
  end

  describe('#capitalize') do
    it ('capitalizes the name before save') do
      test_recipe = create_test_recipe
      expect(test_recipe.name()).to(eq("Test Recipe"))
    end
  end

  describe('#ingredients') do
    it('returns a list of ingredients used in the recipe') do
      test_recipe = create_test_recipe()
      test_ingredient = test_recipe.ingredients.create({
        name: "test ingredient"
        })
      expect(test_recipe.ingredients).to(eq([test_ingredient]))
    end
  end

  describe('#tags') do
    it('returns a list of tags assigned to the recipe') do
      test_recipe = create_test_recipe
      test_tag = test_recipe.tags.create({
        name: "tests"
        })
      expect(test_recipe.tags).to(eq([test_tag]))
    end
  end
end
