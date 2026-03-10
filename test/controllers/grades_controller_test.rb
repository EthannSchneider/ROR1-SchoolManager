require "test_helper"

class GradesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @collaborator = people(:collaborator)
    @student = students(:two)
    @grade = grades(:one)
    @unity = unities(:one)
  end

  test "collaborator views a student's grade history" do
    sign_in @collaborator

    get student_grades_url(@student)
    assert_response :success
  end

  test "student can view another student's grade history" do
    sign_in students(:one)

    get student_grades_url(@student)
    assert_response :success
  end

  test "collaborator opens new grade form" do
    sign_in @collaborator

    get new_student_grade_url(@student)
    assert_response :success
  end

  test "collaborator creates grade" do
    sign_in @collaborator

    assert_difference("Grade.count") do
      post student_grades_url(@student), params: {
        grade: {
          value: 5.5,
          test_date: Date.today,
          unity_id: @unity.id
        }
      }
    end

    assert_redirected_to student_grades_url(@student)
  end

  test "collaborator updates grade" do
    sign_in @collaborator

    patch student_grade_url(@student, @grade), params: {
      grade: {
        value: 4.0,
        test_date: Date.today - 1
      }
    }

    assert_redirected_to student_grades_url(@student)
    @grade.reload
    assert_in_delta 4.0, @grade.value.to_f, 0.001
  end

  test "collaborator deletes grade" do
    sign_in @collaborator

    assert_difference("Grade.count", -1) do
      delete student_grade_url(@student, @grade)
    end

    assert_redirected_to student_grades_url(@student)
  end
end
