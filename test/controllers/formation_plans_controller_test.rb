require "test_helper"

class FormationPlansControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
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
    @formation_plan = formation_plans(:one)
  end

  test "collaborator lists formation plans" do
    sign_in @collaborator

    get formation_plans_url
    assert_response :success
  end

  test "dean creates formation plan" do
    sign_in @dean

    assert_difference("FormationPlan.count") do
      post formation_plans_url, params: {
        formation_plan: {
          name: "Future Plan"
        }
      }
    end

    assert_redirected_to formation_plan_url(FormationPlan.last)
  end

  test "dean updates formation plan" do
    sign_in @dean

    patch formation_plan_url(@formation_plan), params: {
      formation_plan: {
        name: "Updated Plan"
      }
    }

    assert_redirected_to formation_plan_url(@formation_plan)
    @formation_plan.reload
    assert_equal "Updated Plan", @formation_plan.name
  end

  test "dean destroys formation plan" do
    sign_in @dean

    assert_difference("FormationPlan.count", -1) do
      delete formation_plan_url(@formation_plan)
    end

    assert_redirected_to formation_plans_url
  end
end
