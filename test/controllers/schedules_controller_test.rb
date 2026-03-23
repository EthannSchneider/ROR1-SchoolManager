require "test_helper"

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @collaborator = people(:collaborator)
    @school_class = school_classes(:one)
    @room = rooms(:one)
    @unity = unities(:one)
    uniq = SecureRandom.hex(4)
    @dean = Dean.create!(
      email: "dean-schedules-#{uniq}@example.com",
      firstname: "Diana",
      lastname: "Dean",
      avs_number: "756.9999.8888.#{rand(10_000..99_999)}",
      contract_start: Date.current,
      contract_end: Date.current + 365,
      password: "password123"
    )

    @week_twenty_date = Date.commercial(2026, 20, 2)
    @week_twenty_one_date = Date.commercial(2026, 21, 2)

    @person_schedule = Schedule.create!(
      room: @room,
      unity: @unity,
      day: @week_twenty_date,
      start_time: Time.zone.parse("08:15"),
      end_time: Time.zone.parse("10:00"),
      collaborators: [ @collaborator ],
      school_classes: [ @school_class ]
    )

    @class_schedule = Schedule.create!(
      room: rooms(:two),
      unity: unities(:two),
      day: @week_twenty_date + 1.day,
      start_time: Time.zone.parse("13:30"),
      end_time: Time.zone.parse("15:15"),
      school_classes: [ @school_class ]
    )

    @outside_week_schedule = Schedule.create!(
      room: @room,
      unity: @unity,
      day: @week_twenty_one_date,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("10:00"),
      collaborators: [ @collaborator ],
      school_classes: [ @school_class ]
    )
  end

  test "shows person schedule for selected week" do
    sign_in @collaborator

    get person_schedule_path(@collaborator, week: 20, year: 2026)

    assert_response :success
    assert_includes response.body, "Schedule for Alice Martin"
    assert_includes response.body, @person_schedule.unity.name
    assert_not_includes response.body, @outside_week_schedule.day.strftime("%d.%m.%Y")
  end

  test "supports weeks param alias" do
    sign_in @collaborator

    get person_schedule_path(@collaborator, weeks: 20, year: 2026)

    assert_response :success
    assert_includes response.body, @person_schedule.unity.name
  end

  test "shows class schedule for selected week" do
    sign_in @collaborator

    get schedule_school_class_path(@school_class, week: 20, year: 2026)

    assert_response :success
    assert_includes response.body, "Schedule for Class A"
    assert_includes response.body, @class_schedule.unity.name
    assert_not_includes response.body, @outside_week_schedule.day.strftime("%d.%m.%Y")
  end

  test "shows room schedule for selected week" do
    sign_in @collaborator

    get schedule_room_path(@room, week: 20, year: 2026)

    assert_response :success
    assert_includes response.body, "Schedule for Room One"
    assert_includes response.body, @person_schedule.unity.name
    assert_not_includes response.body, @outside_week_schedule.day.strftime("%d.%m.%Y")
  end

  test "dean can access schedules index" do
    sign_in @dean

    get schedules_path

    assert_response :success
    assert_includes response.body, "Schedules"
    assert_includes response.body, @person_schedule.unity.name
  end

  test "collaborator cannot access schedules index" do
    sign_in @collaborator

    get schedules_path

    assert_response :not_found
  end

  test "dean can create schedule from schedules controller" do
    sign_in @dean

    assert_difference("Schedule.count", 1) do
      post schedules_path, params: {
        schedule: {
          room_id: @room.id,
          unity_id: @unity.id,
          day: Date.commercial(2026, 20, 4),
          start_time: "10:15",
          end_time: "11:45",
          collaborator_ids: [ @collaborator.id ],
          school_class_ids: [ @school_class.id ]
        }
      }
    end

    assert_redirected_to schedule_path(Schedule.last)
    assert_equal [ @collaborator.id ], Schedule.last.collaborator_ids
    assert_equal [ @school_class.id ], Schedule.last.school_class_ids
  end
end
