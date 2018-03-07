require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Henk", email: "henk@henk.nl")
    @recipe1 = Recipe.create(name: "Soep", description: "Heerlijke groente soep", chef: @user)
    @recipe2 = @user.recipes.build(name: "Chicken wings", description: "Pittige chicken wings voor pasen")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe1.name, response.body
    assert_match @recipe2.name, response.body
  end
end
