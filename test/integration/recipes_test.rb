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
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_match @recipe2.name, response.body
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
  end

  test "should get show recipe" do
    get recipe_path(@recipe1)
    assert_template 'recipes/show'
    assert_match @recipe1.name, response.body
    assert_match @recipe1.description, response.body
    assert_match @user.chefname, response.body
  end

  test "create new valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "chicken sauce"
    description_of_recipe = "Add chicken, add vegetables, cok for 20 minutes"
    assert_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: name_of_recipe , description: description_of_recipe}}
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end

  test "reject invalid recipe submission" do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: " ", description: " "}}
    end
    assert_template 'recipes/new'
    # assert_select 'h2.panel-title'
    assert_select 'div.notification'
  end
end
