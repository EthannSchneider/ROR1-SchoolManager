require "test_helper"

class StudentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @student = students(:one)
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
    get students_url
    assert_response :success
  end

  test "teacher should get index" do
    sign_in @teacher
    get students_url
    assert_response :success
  end

  test "dean should get index" do
    sign_in @dean
    get students_url
    assert_response :success
  end

  test "dean should get new" do
    sign_in @dean
    get new_student_url
    assert_response :success
  end

  test "dean should create student" do
    sign_in @dean
    assert_difference("Student.count") do
      post students_url, params: { student: { firstname: "John", lastname: "Doe", email: "john-#{SecureRandom.hex(2)}@example.com", avs_number: "756.5555.6666.#{rand(10_000..99_999)}", admission_date: Date.today, end_date: Date.tomorrow, password: "password123" } }
    end

    assert_redirected_to student_url(Student.last)
  end

  test "collaborator should not get new" do
    sign_in @collaborator
    get new_student_url
    assert_response :not_found
  end

  test "teacher should not get new" do
    sign_in @teacher
    get new_student_url
    assert_response :not_found
  end

  test "dean should update student" do
    sign_in @dean
    patch student_url(@student), params: { student: { firstname: "Jane" } }
    assert_redirected_to student_url(@student)
    @student.reload
    assert_equal "Jane", @student.firstname
  end

  test "dean should destroy student" do
    sign_in @dean
    assert_difference("Student.count", -1) do
      delete student_url(@student)
    end
    assert_redirected_to students_url
  end

  test "person should get index" do
    sign_in @person
    get students_url
    assert_response :success
  end

  test "person should show student" do
    sign_in @person
    get student_url(@student)
    assert_response :success
    assert_no_match "AVS number:", response.body
    assert_no_match "Phone number:", response.body
    assert_no_match "Street:", response.body
    assert_no_match "Postal code:", response.body
    assert_no_match "City:", response.body
  end

  test "collaborator should show student" do
    sign_in @collaborator
    get student_url(@student)
    assert_response :success
    assert_match "AVS number:", response.body
    assert_match "Phone number:", response.body
    assert_match "Street:", response.body
    assert_match "Postal code:", response.body
    assert_match "City:", response.body
  end
end
