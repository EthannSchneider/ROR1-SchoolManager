require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @room = rooms(:one)
    @school_class = school_classes(:one)
    @unity = unities(:one)
    uniq = SecureRandom.hex(4)

    @dean = Dean.create!(
      email: "dean-rooms-#{uniq}@example.com",
      firstname: "Diana",
      lastname: "Dean",
      avs_number: "756.5555.6666.#{rand(10_000..99_999)}",
      contract_start: Date.current,
      contract_end: Date.current + 365,
      password: "password123"
    )

    @collaborator = Collaborator.create!(
      email: "collaborator-rooms-#{uniq}@example.com",
      firstname: "Alice",
      lastname: "Martin",
      avs_number: "756.7777.8888.#{rand(10_000..99_999)}",
      contract_start: Date.current,
      contract_end: Date.current + 365,
      password: "password123"
    )
  end

  test "dean can view rooms index" do
    sign_in @dean

    get rooms_url

    assert_response :success
    assert_includes response.body, @room.name
  end

  test "collaborator can view rooms index" do
    sign_in @collaborator

    get rooms_url

    assert_response :success
    assert_includes response.body, @room.name
  end

  test "room show links to the room schedule" do
    sign_in @collaborator

    get room_url(@room)

    assert_response :success
    assert_select "a[href='#{schedule_room_path(@room)}']", text: "View room schedule"
  end

  test "collaborator cannot create room" do
    sign_in @collaborator

    post rooms_url, params: {
      room: {
        name: "Room 204"
      }
    }

    assert_response :not_found
  end

  test "dean should get new" do
    sign_in @dean

    get new_room_url

    assert_response :success
  end

  test "dean should create room" do
    sign_in @dean

    assert_difference("Room.count") do
      post rooms_url, params: {
        room: {
          name: "Room 203"
        }
      }
    end

    assert_redirected_to room_url(Room.last)
    assert_equal "Room 203", Room.last.name
  end

  test "collaborator should not get new" do
    sign_in @collaborator

    get new_room_url

    assert_response :not_found
  end
end
