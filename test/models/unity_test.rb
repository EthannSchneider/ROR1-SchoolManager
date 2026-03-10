require "test_helper"

class UnityTest < ActiveSupport::TestCase
  test "valid unity needs a name and formation module" do
    unity = Unity.new(
      name: "Standalone Unity",
      formation_module: formation_modules(:one)
    )

    assert unity.valid?
  end

  test "requires a name" do
    unity = Unity.new(formation_module: formation_modules(:one))

    assert_not unity.valid?
    assert_includes unity.errors[:name], "can't be blank"
  end

  test "requires a formation module" do
    unity = Unity.new(name: "Nameless Module")

    assert_not unity.valid?
    assert unity.errors.key?(:formation_module)
  end
end
