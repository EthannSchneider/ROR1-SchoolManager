require "test_helper"

class ScheduleTest < ActiveSupport::TestCase
  fixtures :formation_modules, :rooms, :unities

  setup do
    @room = rooms(:one)
    @unity = unities(:one)
  end

  def build_schedule(overrides = {})
    defaults = {
      day: Date.today,
      start_time: "10:00",
      end_time: "11:00",
      room: @room,
      unity: @unity
    }

    Schedule.new(defaults.merge(overrides))
  end

  test "is valid with a set of good attributes" do
    schedule = build_schedule

    assert schedule.valid?
  end

  test "requires day, start_time, and end_time" do
    schedule = build_schedule(day: nil, start_time: nil, end_time: nil)

    assert_not schedule.valid?
    assert_includes schedule.errors[:day], "can't be blank"
    assert_includes schedule.errors[:start_time], "can't be blank"
    assert_includes schedule.errors[:end_time], "can't be blank"
  end

  test "requires end_time after start_time" do
    schedule = build_schedule
    schedule.end_time = schedule.start_time

    assert_not schedule.valid?
    assert_includes schedule.errors[:end_time], "must be after the start time"
  end
end
