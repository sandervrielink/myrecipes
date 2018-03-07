require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest

  test "should get signup path" do
    get signup_path
    assert_response :success
  end

  test "reject on invalid signup" do
    get signup_path
    assert_no_difference "Chef.count" do
      post chefs_path, params: { chef: { chefname: " ", email: " ", password: "password",
                              password_confirmation: " " } }
    end
    assert_template 'chefs/new'
    assert_select 'div.notification'
  end

  test "accept valid signup" do

  end
end
