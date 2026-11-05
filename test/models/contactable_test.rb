require "test_helper"

class ContactableTest < ActiveSupport::TestCase
  test "email is normalized before saving" do
    client = Client.create!(name: "Pat", email: "  Pat@Example.COM ")
    assert_equal "pat@example.com", client.email
  end

  test "email has to be unique, ignoring case" do
    assert_not Provider.new(name: "Dupe", email: "DANA@example.com").valid?
  end

  test "name and email are required" do
    client = Client.new
    assert_not client.valid?
    assert client.errors.key?(:name)
    assert client.errors.key?(:email)
  end
end
