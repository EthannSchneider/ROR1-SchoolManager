require "test_helper"

class SchoolClassesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @school_class = school_classes(:one)
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
    get school_classes_url
    assert_response :success
  end

  test "person should get show" do
    sign_in @person
    get school_class_url(@school_class)
    assert_response :success
  end

  test "dean should get new" do
    sign_in @dean
    get new_school_class_url
    assert_response :success
  end

  test "dean should create school class" do
    sign_in @dean

    assert_difference("SchoolClass.count") do
      post school_classes_url, params: {
        school_class: {
          name: "Class Z",
          responsable_id: @collaborator.id,
          student_ids: [ students(:two).id ]
        }
      }
    end

    assert_redirected_to school_class_url(SchoolClass.last)
    assert_equal [ students(:two).id ], SchoolClass.last.student_ids
  end

  test "collaborator should not get new" do
    sign_in @collaborator
    get new_school_class_url
    assert_response :not_found
  end

  test "dean should update school class" do
    sign_in @dean
    patch school_class_url(@school_class), params: {
      school_class: {
        name: "Class Updated",
        student_ids: [ students(:two).id ]
      }
    }
    assert_redirected_to school_class_url(@school_class)
    @school_class.reload
    assert_equal "Class Updated", @school_class.name
    assert_equal [ students(:two).id ], @school_class.student_ids
  end

  test "dean should get paginated students on edit page" do
    sign_in @dean
    30.times do |index|
      Student.create!(
        email: "student-page-#{index}-#{SecureRandom.hex(2)}@example.com",
        firstname: "Student#{index}",
        lastname: "Pagination#{index}",
        avs_number: "756.77#{format('%02d', index)}.88#{format('%02d', index)}.#{rand(10_000..99_999)}",
        admission_date: Date.today,
        end_date: Date.today + 30,
        password: "password123"
      )
    end

    get edit_school_class_url(@school_class)
    assert_response :success
    assert_select "a[href*='students_page=2']", text: /Next/
  end

  test "dean should destroy school class" do
    sign_in @dean
    class_to_delete = SchoolClass.create!(name: "Class Delete", responsable: @collaborator)

    assert_difference("SchoolClass.count", -1) do
      delete school_class_url(class_to_delete)
    end

    assert_redirected_to school_classes_url
  end
end
