class StudentTest < ActiveSupport::TestCase
  class StudentTest < ActiveSupport::TestCase
    def setup
      @person = Person.create!(firstname: "John", lastname: "Doe", email: "john@example.com", avs_number: "123456789", password: "password")
    end

    test "should require admission_date" do
      student = Student.new(end_date: Date.today, firstname: "Jane", lastname: "Smith", email: "jane@example.com", avs_number: "987654321")
      assert_not student.valid?
      assert_includes student.errors[:admission_date], "can't be blank"
    end

    test "should require end_date" do
      student = Student.new(admission_date: Date.today, firstname: "Jane", lastname: "Smith", email: "jane@example.com", avs_number: "987654321")
      assert_not student.valid?
      assert_includes student.errors[:end_date], "can't be blank"
    end

    test "should create valid student" do
      student = Student.new(admission_date: Date.today, end_date: 1.year.from_now, firstname: "Jane", lastname: "Smith", email: "jane@example.com", avs_number: "987654321", password: "password")
      assert student.valid?
    end

    test "should inherit Person validations" do
      student = Student.new(admission_date: Date.today, end_date: Date.tomorrow)
      assert_not student.valid?
      assert_includes student.errors[:email], "can't be blank"
      assert_includes student.errors[:firstname], "can't be blank"
    end
  end
end
