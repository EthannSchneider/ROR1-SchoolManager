class GradesController < ApplicationController
  before_action :set_grade, only: %i[edit update destroy]
  before_action :set_student
  before_action :require_collaborator!, only: %i[edit update destroy]
  before_action :check_student_ownership!, only: %i[index]

  def index
    @grades = @student.grades
  end

  def new
    @grade = Grade.new
  end

  def create
    @grade = Grade.new(new_grade_params)
    @grade.student = @student

    if @grade.save
      redirect_to student_grades_path(@student), notice: "Grade was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @grade.update(edit_grade_params)
      redirect_to student_grades_path(@student), notice: "Grade was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @grade.delete
    redirect_to student_grades_path(@student), notice: "Grade was successfully deleted."
  end

  private

  def set_grade
    @grade = Grade.includes(:student, :unity).find(params[:id])
  end

  def set_student
    @student = Student.find(params[:student_id])
  end

  def check_student_ownership!
    if current_person.is_a?(Student) && current_person != @student
      head :forbidden
    end
  end

  def new_grade_params
    params.require(:grade).permit(
      :value,
      :test_date,
      :unity_id
    )
  end

  def edit_grade_params
    params.require(:grade).permit(
      :value,
      :test_date
    )
  end
end
