require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Henk", email: "henk@henk.nl")
    @recipe = Recipe.create(name: "Soep", description: "Heerlijke groente soep", chef: @user)
  end

  test "reject invalid recipe udate" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: { name: " ", description: "Something..."} }
    assert_template 'recipes/edit'
    assert_select 'div.notification'
  end

  test "succefully edited the recipe" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "updated recipe name"
    updated_description = "updated description"
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description}}
    assert_redirected_to @recipe
    #follow_redirect!
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end


end
