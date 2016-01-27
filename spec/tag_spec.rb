require "spec_helper"

describe(Tag) do
  describe('#recipes') do
    it('returns a list of recipes that use this tag') do
      test_recipe = create_test_recipe()
      test_tag = test_recipe.tags.create({
        name: "test tag"
        })
      expect(test_tag.recipes).to(eq([test_recipe]))
    end
  end
end
