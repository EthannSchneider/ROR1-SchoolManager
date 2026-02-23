require "test_helper"

class PersonTest < ActiveSupport::TestCase
  test "should create person with valid attributes" do
    person = Person.new(
      email: "test@example.com",
      firstname: "John",
      lastname: "Doe",
      avs_number: "756.1234.5678.33",
      password: "password123",
      password_confirmation: "password123"
    )
    assert person.valid?
  end

  test "should not create person without email" do
    person = Person.new(firstname: "John", lastname: "Doe", avs_number: "756.1234.5678.90")
    assert_not person.valid?
    assert person.errors[:email].any?
  end

  test "should not create person with duplicate email" do
    Person.create!(
      email: "test@example.com",
      firstname: "John",
      lastname: "Doe",
      avs_number: "756.1234.5633.33",
      password: "password123"
    )
    person = Person.new(
      email: "test@example.com",
      firstname: "Jane",
      lastname: "Smith",
      avs_number: "756.9876.5432.12",
      password: "password123"
    )
    assert_not person.valid?
  end

  test "should not create person with duplicate avs_number" do
    Person.create!(
      email: "test1@example.com",
      firstname: "John",
      lastname: "Doe",
      avs_number: "756.1234.5678.95",
      password: "password123"
    )
    person = Person.new(
      email: "test2@example.com",
      firstname: "Jane",
      lastname: "Smith",
      avs_number: "756.1234.5678.95",
      password: "password123"
    )
    assert_not person.valid?
  end
end
