require "test_helper"

class RoomTest < ActiveSupport::TestCase
  fixtures :rooms

  test "is invalid without a name" do
    room = Room.new

    assert_not room.valid?
    assert_includes room.errors[:name], "can't be blank"
  end

  test "enforces unique names" do
    existing_room = rooms(:one)
    room = Room.new(name: existing_room.name)

    assert_not room.valid?
    assert_includes room.errors[:name], "has already been taken"
  end
end
