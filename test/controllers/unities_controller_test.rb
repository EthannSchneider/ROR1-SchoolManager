require "test_helper"

class UnitiesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @formation_plan = FormationPlan.create!(name: "Unity Plan")
    @formation_module = FormationModule.create!(name: "Unity Module")
    @formation_plan.formation_modules << @formation_module
    @unity = @formation_module.unities.create!(name: "Existing Unity")
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

    @collaborator = people(:collaborator)
  end

  test "collaborator views a unity" do
    sign_in @collaborator

    get formation_plan_formation_module_unity_url(@formation_plan, @formation_module, @unity)
    assert_response :success
  end

  test "dean views the new unity form" do
    sign_in @dean

    get new_formation_plan_formation_module_unity_url(@formation_plan, @formation_module)
    assert_response :success
  end

  test "dean creates unity" do
    sign_in @dean

    assert_difference("Unity.count") do
      post formation_plan_formation_module_unities_url(@formation_plan, @formation_module), params: {
        unity: {
          name: "Created Unity"
        }
      }
    end

    assert_redirected_to formation_plan_formation_module_unity_url(@formation_plan, @formation_module, Unity.last)
  end

  test "dean updates unity" do
    sign_in @dean

    patch formation_plan_formation_module_unity_url(@formation_plan, @formation_module, @unity), params: {
      unity: {
        name: "Updated Unity"
      }
    }

    assert_redirected_to formation_plan_formation_module_unity_url(@formation_plan, @formation_module, @unity)
    @unity.reload
    assert_equal "Updated Unity", @unity.name
  end

  test "dean destroys unity" do
    sign_in @dean

    assert_difference("Unity.count", -1) do
      delete formation_plan_formation_module_unity_url(@formation_plan, @formation_module, @unity)
    end

    assert_redirected_to formation_plan_formation_module_url(@formation_plan, @formation_module)
  end
end
