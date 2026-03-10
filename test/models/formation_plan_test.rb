require "test_helper"

class FormationPlanTest < ActiveSupport::TestCase
  test "requires a name" do
    plan = FormationPlan.new

    assert_not plan.valid?
    assert_includes plan.errors[:name], "can't be blank"
  end

  test "aggregates unities through formation modules" do
    plan = FormationPlan.create!(name: "Plan With Modules")
    mod = FormationModule.create!(name: "Module For Plan")
    unity = mod.unities.create!(name: "Plan Unity")
    plan.formation_modules << mod

    assert_includes plan.unities, unity
  end
end
