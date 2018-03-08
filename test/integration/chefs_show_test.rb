require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Henk", email: "henk@henk.nl",
                          password: "password", password_confirmation: "password")
    @recipe1 = Recipe.create(name: "Soep", description: "Heerlijke groente soep", chef: @user)
    @recipe2 = @user.recipes.build(name: "Chicken wings", description: "Pittige chicken wings voor pasen")
    @recipe2.save
  end

  test "should get chefs show" do
    get chef_path(@user)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe1), text: @recipe1.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe1.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @user.chefname, response.body
  end
end
