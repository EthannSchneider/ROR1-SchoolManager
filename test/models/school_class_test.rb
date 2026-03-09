require "test_helper"

class SchoolClassTest < ActiveSupport::TestCase
  setup do
    @responsable = Collaborator.find(people(:collaborator).id)
  end

  test "should be valid with valid attributes" do
    school_class = SchoolClass.new(name: "Class B", responsable: @responsable)
    assert school_class.valid?
  end

  test "should be invalid without name" do
    school_class = SchoolClass.new(responsable: @responsable)
    assert_not school_class.valid?
    assert_includes school_class.errors[:name], "can't be blank"
  end

  test "should be invalid without responsable" do
    school_class = SchoolClass.new(name: "Class C")
    assert_not school_class.valid?
    assert_includes school_class.errors[:responsable], "must exist"
  end
end
