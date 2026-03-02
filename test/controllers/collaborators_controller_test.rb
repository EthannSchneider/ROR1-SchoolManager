require "test_helper"

class CollaboratorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    uniq = SecureRandom.hex(4)

    @dean = Dean.create!(
      email: "dean-#{uniq}@example.com",
      firstname: "Diana",
      lastname: "Dean",
      avs_number: "756.1111.2222.#{rand(10_000..99_999)}",
      contract_start: Date.today,
      contract_end: Date.today + 365,
      password: "password123"
    )

    @teacher = Teacher.create!(
      email: "teacher-#{uniq}@example.com",
      firstname: "Tom",
      lastname: "Teacher",
      avs_number: "756.2222.3333.#{rand(10_000..99_999)}",
      contract_start: Date.today,
      contract_end: Date.today + 365,
      password: "password123"
    )

    @collaborator = Collaborator.create!(
      email: "collaborator-#{uniq}@example.com",
      firstname: "Alice",
      lastname: "Martin",
      avs_number: "756.3333.4444.#{rand(10_000..99_999)}",
      contract_start: Date.today,
      contract_end: Date.today + 365,
      password: "password123"
    )

    @person = Person.create!(
      email: "person-#{uniq}@example.com",
      firstname: "John",
      lastname: "Doe",
      avs_number: "756.4444.5555.#{rand(10_000..99_999)}",
      password: "password123"
    )
  end

  test "collaborator should get index" do
    sign_in @collaborator
    get collaborators_url
    assert_response :success
  end

  test "teacher should get show" do
    sign_in @teacher
    get collaborator_url(@collaborator)
    assert_response :success
  end

  test "dean should get new" do
    sign_in @dean
    get new_collaborator_url
    assert_response :success
  end

  test "dean should create collaborator" do
    sign_in @dean
    assert_difference("Collaborator.count") do
      post collaborators_url, params: { collaborator: { firstname: "Carl", lastname: "Cooper", email: "new-collab-#{SecureRandom.hex(2)}@example.com", avs_number: "756.7777.8888.#{rand(10_000..99_999)}", contract_start: Date.today, contract_end: Date.today + 365, password: "password123" } }
    end

    assert_redirected_to collaborator_url(Collaborator.last)
  end

  test "dean should create teacher via type field" do
    sign_in @dean
    assert_difference("Teacher.count") do
      post collaborators_url, params: { collaborator: { firstname: "Tina", lastname: "Type", email: "typed-collab-#{SecureRandom.hex(2)}@example.com", avs_number: "756.6666.7777.#{rand(10_000..99_999)}", contract_start: Date.today, contract_end: Date.today + 365, password: "password123", type: "Teacher" } }
    end

    assert_redirected_to collaborator_url(Collaborator.last)
    assert_instance_of Teacher, Collaborator.last
  end

  test "dean should update collaborator" do
    sign_in @dean
    patch collaborator_url(@collaborator), params: { collaborator: { firstname: "Updated" } }
    assert_redirected_to collaborator_url(@collaborator)
    @collaborator.reload
    assert_equal "Updated", @collaborator.firstname
  end

  test "dean should destroy collaborator" do
    sign_in @dean
    assert_difference("Collaborator.count", -1) do
      delete collaborator_url(@collaborator)
    end

    assert_redirected_to collaborators_url
  end

  test "teacher should not get new" do
    sign_in @teacher
    get new_collaborator_url
    assert_response :not_found
  end

  test "collaborator should not create collaborator" do
    sign_in @collaborator
    assert_no_difference("Collaborator.count") do
      post collaborators_url, params: { collaborator: { firstname: "Blocked", lastname: "Blocked", email: "blocked-#{SecureRandom.hex(2)}@example.com", avs_number: "756.9999.0000.#{rand(10_000..99_999)}", contract_start: Date.today, contract_end: Date.today + 365, password: "password123" } }
    end

    assert_response :not_found
  end

  test "person should get collaborators index" do
    sign_in @person
    get collaborators_url
    assert_response :success
  end
end
