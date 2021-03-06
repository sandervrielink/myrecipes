require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: "Sander", email: "sander@sander.nl",
                      password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "chefname should be present" do
    @chef.chefname = " "
    assert_not @chef.valid?
  end

  test "chefname should be less than 30 characters" do
    @chef.chefname = "a" * 31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = " "
    assert_not @chef.valid?
  end

  test "email should not ben longer than 255" do
    @chef.email = "a" * 245 + "example.com"
    assert_not @chef.valid?
  end

  test "email should accept correct format" do
    valid_emails = %w[user@example.com SANDER@gmail.com m.first@yahoo.ca john+smit@co.nl]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{valids.inspect} should be valid"
    end
  end

  test "email should reject invalid format" do
    invalid_emails = %w[user@examplecom @gmail.com m.firstyahoo.ca john+smit@]
    invalid_emails.each do |invalids|
      @chef.email = invalids
      assert_not @chef.valid?, "#{invalids.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
      duplicate_chef = @chef.dup
      duplicate_chef.email = @chef.email.upcase
      @chef.save
      assert_not duplicate_chef.valid?
  end

  test "email should be lower case before hitting db" do
    mixed_email = "JOhn@exAmple.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = " "
    assert_not @chef.valid?
  end

  test "PAssword should be at least 5 characters" do
    @chef.password = @chef.password_confirmation = "a" * 4
    assert_not @chef.valid?
  end

  test "associated recipes should be destroyed" do
  @chef.save
  @chef.recipes.create!(name: "testing delete",
                  description: "testing delete function")
  assert_difference 'Recipe.count', -1 do
    @chef.destroy
  end
  end
end
