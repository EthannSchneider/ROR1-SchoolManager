require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = students(:one)
    uniq = SecureRandom.hex(4)
    @collaborator = Collaborator.create!(
      email: "collaborator-#{uniq}@example.com",
      firstname: "Alice",
      lastname: "Martin",
      avs_number: "756.1111.2222.#{rand(10_000..99_999)}",
      contract_start: Date.today,
      contract_end: Date.today + 365,
      password: "password123"
    )
    @person = Person.create!(
      email: "admin-#{uniq}@example.com",
      firstname: "John",
      lastname: "Doe",
      avs_number: "756.1234.5678.#{rand(10_000..99_999)}",
      password: "password123"
    )
  end

  test "should get index" do
    sign_in @person
    get students_url
    assert_response :success
  end

  test "should get index with custom per_page" do
    sign_in @person
    get students_url, params: { per_page: 20 }
    assert_response :success
  end

  test "should get index with per_page capped at 100" do
    sign_in @person
    get students_url, params: { per_page: 500 }
    assert_response :success
  end

  test "should get new" do
    sign_in @collaborator
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    sign_in @collaborator
    assert_difference("Student.count") do
      post students_url, params: { student: { firstname: "John", lastname: "Doe", email: "john@example.com", avs_number: "123456789", admission_date: Date.today, end_date: Date.tomorrow, password: "password123" } }
    end
    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    sign_in @person
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    sign_in @collaborator
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    sign_in @collaborator
    patch student_url(@student), params: { student: { firstname: "Jane" } }
    assert_redirected_to student_url(@student)
    @student.reload
    assert_equal "Jane", @student.firstname
  end

  test "should destroy student" do
    sign_in @collaborator
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end
    assert_redirected_to students_url
  end

  test "non collaborator should not get new" do
    sign_in @person
    get new_student_url
    assert_response :not_found
  end

  test "non collaborator should not create student" do
    sign_in @person
    assert_no_difference("Student.count") do
      post students_url, params: { student: { firstname: "John", lastname: "Doe", email: "blocked@example.com", avs_number: "99887766554", admission_date: Date.today, end_date: Date.tomorrow, password: "password123" } }
    end
    assert_response :not_found
  end

  test "non collaborator should not get edit" do
    sign_in @person
    get edit_student_url(@student)
    assert_response :not_found
  end

  test "non collaborator should not update student" do
    sign_in @person
    patch student_url(@student), params: { student: { firstname: "Blocked" } }
    assert_response :not_found
  end

  test "non collaborator should not destroy student" do
    sign_in @person
    assert_no_difference("Student.count") do
      delete student_url(@student)
    end
    assert_response :not_found
  end
end
