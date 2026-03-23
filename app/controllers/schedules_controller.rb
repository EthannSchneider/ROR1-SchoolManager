class SchedulesController < ApplicationController
  before_action :set_schedule, only: %i[show edit update destroy]
  before_action :set_person, only: :person
  before_action :set_school_class, only: :school_class
  before_action :set_room, only: :room
  before_action :require_dean!, only: %i[index new create edit update destroy]
  before_action :set_schedule_collections, only: %i[new create edit update]

  def index
    @schedules = Schedule
      .includes(:room, :unity, :collaborators, :school_classes)
      .order(day: :desc, start_time: :asc)
  end

  def show
    render :show_record
  end

  def new
    @schedule = Schedule.new(day: Date.current)
  end

  def edit
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.save
      redirect_to schedule_path(@schedule), notice: "Schedule was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to schedule_path(@schedule), notice: "Schedule was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy
    redirect_to schedules_path, notice: "Schedule was successfully deleted."
  end

  def person
    week_range = selected_week_range
    schedules = schedules_for_person(@person, week_range)
    render_schedule(
      title: "Schedule for #{@person.full_name}",
      back_path: safe_person_path(@person),
      schedules: schedules,
      week_range: week_range
    )
  end

  def school_class
    week_range = selected_week_range
    schedules = schedules_for_school_class(@school_class, week_range)
    render_schedule(
      title: "Schedule for #{@school_class.name}",
      back_path: school_class_path(@school_class),
      schedules: schedules,
      week_range: week_range
    )
  end

  def room
    week_range = selected_week_range
    schedules = schedules_for_room(@room, week_range)
    render_schedule(
      title: "Schedule for #{@room.name}",
      back_path: room_path(@room),
      schedules: schedules,
      week_range: week_range
    )
  end

  private

  def render_schedule(title:, back_path:, schedules:, week_range:)
    @title = title
    @back_path = back_path
    @calendar_start = week_range.begin
    @calendar_end = @calendar_start + 6.days
    @previous_week_params = week_params_for(@calendar_start - 1.week)
    @next_week_params = week_params_for(@calendar_start + 1.week)
    @week_days = (@calendar_start..@calendar_end).to_a
    @events_by_day = schedule_events_for_week(schedules).group_by { |event| event[:day] }

    render :show
  end

  def selected_week_start
    year = params[:year].presence&.to_i || Date.current.cwyear
    week = params[:week].presence || params[:weeks].presence
    week = week.to_i if week.present?
    week = Date.current.cweek unless week&.positive?

    Date.commercial(year, week, 1)
  rescue Date::Error
    Date.current.beginning_of_week(:monday)
  end

  def selected_week_range
    start_date = selected_week_start
    start_date..(start_date + 6.days)
  end

  def week_params_for(date)
    { week: date.cweek, year: date.cwyear }
  end

  def schedules_for_person(person, week_range)
    return Schedule.none unless person.is_a?(Collaborator)

    person.schedules
      .includes(:room, unity: :formation_module, school_classes: :formation_plan)
      .where(day: week_range)
      .order(:day, :start_time)
  end

  def schedules_for_school_class(school_class, week_range)
    school_class.schedules
      .includes(:room, unity: :formation_module, collaborators: [], school_classes: :formation_plan)
      .where(day: week_range)
      .order(:day, :start_time)
  end

  def schedules_for_room(room, week_range)
    room.schedules
      .includes(:room, unity: :formation_module, collaborators: [], school_classes: :formation_plan)
      .where(day: week_range)
      .order(:day, :start_time)
  end

  def schedule_events_for_week(schedules)
    schedules.filter_map do |schedule|
      next if schedule.day.blank? || schedule.start_time.blank?

      {
        id: schedule.id,
        day: schedule.day,
        title: schedule_title(schedule),
        start_time: schedule.start_time,
        end_time: schedule.end_time,
        room: schedule.room&.name,
        unity: schedule.unity&.name,
        classes: schedule.school_classes.map(&:name)
      }
    end
  end

  def schedule_title(schedule)
    schedule.unity&.name.presence || "Course"
  end

  def safe_person_path(person)
    polymorphic_path(person)
  rescue ActionController::UrlGenerationError
    root_path
  end

  def set_schedule
    @schedule = Schedule.includes(:room, :unity, :collaborators, :school_classes).find(params[:id])
  end

  def set_person
    @person = Person.find(params[:person_id])
  end

  def set_school_class
    @school_class = SchoolClass.find(params[:id])
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def set_schedule_collections
    @rooms = Room.order(:name)
    @unities = Unity.order(:name)
    @collaborators = Collaborator.order(:lastname, :firstname)
    @school_classes = SchoolClass.order(:name)
  end

  def schedule_params
    params.require(:schedule).permit(
      :room_id,
      :unity_id,
      :day,
      :start_time,
      :end_time,
      collaborator_ids: [],
      school_class_ids: []
    )
  end
end
