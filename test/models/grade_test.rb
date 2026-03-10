require "test_helper"

class GradeTest < ActiveSupport::TestCase
  test "valid grade with required attributes" do
    grade = Grade.new(
      value: 4.5,
      test_date: Date.today,
      student: students(:one),
      unity: unities(:one)
    )

    assert grade.valid?
  end

  test "is invalid without a value" do
    grade = Grade.new(
      test_date: Date.today,
      student: students(:one),
      unity: unities(:one)
    )

    assert_not grade.valid?
    assert_includes grade.errors[:value], "can't be blank"
  end

  test "enforces allowed value range" do
    grade = Grade.new(
      value: 7,
      test_date: Date.today,
      student: students(:one),
      unity: unities(:one)
    )

    assert_not grade.valid?
    assert_includes grade.errors[:value], "must be less than or equal to 6"
  end

  test "requires a test date" do
    grade = Grade.new(
      value: 3.2,
      student: students(:one),
      unity: unities(:one)
    )

    assert_not grade.valid?
    assert_includes grade.errors[:test_date], "can't be blank"
  end
end
