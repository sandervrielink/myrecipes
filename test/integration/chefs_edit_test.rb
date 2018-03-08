require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Henk", email: "henk@henk.nl",
                          password: "password", password_confirmation: "password")
  end

  test "reject on invalid edit" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "henke@henk.nl" } }
    assert_template 'chefs/edit'
    assert_select 'div.notification'
  end

  test "accept valid signup" do
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "henk12", email: "henk12@henk.nl" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "henk12", @chef.chefname
    assert_match "henk12@henk.nl", @chef.email
  end

end
