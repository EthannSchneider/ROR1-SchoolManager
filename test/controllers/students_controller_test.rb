require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = students(:one)
    @person = people(:admin)
    sign_in @person
  end

  test "should get index" do
    get students_url
    assert_response :success
  end

  test "should get index with custom per_page" do
    get students_url, params: { per_page: 20 }
    assert_response :success
  end

  test "should get index with per_page capped at 100" do
    get students_url, params: { per_page: 500 }
    assert_response :success
  end

  test "should get new" do
    get new_student_url
    assert_response :success
  end

  test "should create student" do
    assert_difference("Student.count") do
      post students_url, params: { student: { firstname: "John", lastname: "Doe", email: "john@example.com", avs_number: "123456789", admission_date: Date.today, end_date: Date.tomorrow, password: "password123" } }
    end
    assert_redirected_to student_url(Student.last)
  end

  test "should show student" do
    get student_url(@student)
    assert_response :success
  end

  test "should get edit" do
    get edit_student_url(@student)
    assert_response :success
  end

  test "should update student" do
    patch student_url(@student), params: { student: { firstname: "Jane" } }
    assert_redirected_to student_url(@student)
    @student.reload
    assert_equal "Jane", @student.firstname
  end

  test "should destroy student" do
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end
    assert_redirected_to students_url
  end
end
