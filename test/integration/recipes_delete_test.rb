require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Henk", email: "henk@henk.nl")
    @recipe = Recipe.create(name: "Soep", description: "Heerlijke groente soep", chef: @user)
  end

  test "succesfully delete a recipe" do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: "Verwijder Recept"
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end

end