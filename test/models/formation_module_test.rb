require "test_helper"

class FormationModuleTest < ActiveSupport::TestCase
  test "requires a name" do
    mod = FormationModule.new

    assert_not mod.valid?
    assert_includes mod.errors[:name], "can't be blank"
  end

  test "destroys dependent unities" do
    mod = FormationModule.create!(name: "Module With Unity")
    mod.unities.create!(name: "Dependent Unity")

    assert_difference("Unity.count", -1) do
      mod.destroy
    end
  end
end
