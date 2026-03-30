require "test_helper"

class FormationModulesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @formation_plan = FormationPlan.create!(name: "Plan with Modules")
    @existing_module = FormationModule.create!(name: "Existing Module")
    @formation_plan.formation_modules << @existing_module
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

  test "collaborator views a formation module" do
    sign_in @collaborator

    get formation_plan_formation_module_url(@formation_plan, @existing_module)
    assert_response :success
  end

  test "dean sees new formation module form" do
    sign_in @dean

    get new_formation_plan_formation_module_url(@formation_plan)
    assert_response :success
  end

  test "dean creates formation module" do
    sign_in @dean

    assert_difference("FormationModule.count") do
      post formation_plan_formation_modules_url(@formation_plan), params: {
        formation_module: {
          name: "New Module"
        }
      }
    end

    assert_redirected_to formation_plan_formation_module_url(@formation_plan, FormationModule.last)
    assert_includes @formation_plan.reload.formation_modules, FormationModule.last
  end

  test "dean sees validation errors when module is invalid" do
    sign_in @dean

    assert_no_difference("FormationModule.count") do
      post formation_plan_formation_modules_url(@formation_plan), params: {
        formation_module: {
          name: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "dean destroys formation module" do
    module_to_destroy = FormationModule.create!(name: "Module To Delete")
    @formation_plan.formation_modules << module_to_destroy
    sign_in @dean

    assert_difference("FormationModule.count", -1) do
      delete formation_plan_formation_module_url(@formation_plan, module_to_destroy)
    end

    assert_redirected_to formation_plan_url(@formation_plan)
  end
end
