require "spec_helper"

describe(Tag) do
  it('validates the uniqueness of the name of the tag') do
    test_tag = create_test_tag
    second_tag_with_same_name = Tag.new({name: "test tag"})
    third_tag_with_same_name_capitalized = Tag.new({name: "Test Tag"})
    expect(second_tag_with_same_name.save).to(eq(false))
    expect(third_tag_with_same_name_capitalized.save).to(eq(false))
  end

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
