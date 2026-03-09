class TeachersController < ApplicationController
  before_action :set_teacher, only: :show

  def index
    per_page = pagination_per_page_value
    @teachers = Teacher.all.page(params[:page]).per(per_page)
    @pagination_per_page = per_page
  end

  def show
  end

  private

  def set_teacher
    @teacher = Teacher.find(params[:id])
  end
end
