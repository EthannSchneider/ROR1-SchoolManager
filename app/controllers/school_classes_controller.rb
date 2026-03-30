class SchoolClassesController < ApplicationController
  before_action :set_school_class, only: %i[show edit update destroy]
  before_action :require_dean!, only: %i[new create edit update destroy]
  before_action :set_students_for_picker, only: %i[new edit]

  def index
    per_page = pagination_per_page_value
    @school_classes = SchoolClass.includes(:responsable, :students).page(params[:page]).per(per_page)
    @pagination_per_page = per_page
  end

  def show
    @ordered_students = @school_class.students.order(:lastname, :firstname)
    @formation_plan = @school_class.formation_plan
  end

  def new
    @school_class = SchoolClass.new
  end

  def edit
  end

  def create
    @school_class = SchoolClass.new(school_class_params)

    if @school_class.save
      redirect_to school_class_url(@school_class), notice: "Class was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @school_class.update(school_class_params)
      redirect_to school_class_url(@school_class), notice: "Class was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @school_class.destroy
    redirect_to school_classes_url, notice: "Class was successfully destroyed."
  end

  private

  def set_school_class
    @school_class = SchoolClass.includes(:responsable, :students).find(params[:id])
  end

  def school_class_params
    params.require(:school_class).permit(:name, :responsable_id, student_ids: [])
  end

  def set_students_for_picker
    per_page = params[:students_per_page].to_i
    per_page = 25 if per_page <= 0
    per_page = 100 if per_page > 100

    @students_per_page = per_page
    @students_page = Student.order(:lastname, :firstname).page(params[:students_page]).per(@students_per_page)
  end
end
