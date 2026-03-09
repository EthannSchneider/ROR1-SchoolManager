class FormationPlansController < ApplicationController
  before_action :set_formation_plan, only: %i[show edit update destroy]
  before_action :require_dean!, only: %i[new create edit update destroy]

  def index
    per_page = pagination_per_page_value
    @formation_plans = FormationPlan.includes(:formation_modules).page(params[:page]).per(per_page)
    @pagination_per_page = per_page
  end

  def show
  end

  def new
    @formation_plan = FormationPlan.new
  end

  def edit
  end

  def create
    @formation_plan = FormationPlan.new(formation_plan_params)

    if @formation_plan.save
      redirect_to formation_plan_url(@formation_plan), notice: "Formation plan was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @formation_plan.update(formation_plan_params)
      redirect_to formation_plan_url(@formation_plan), notice: "Formation plan was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @formation_plan.destroy
    redirect_to formation_plans_url, notice: "Formation plan was successfully destroyed."
  end

  private

  def set_formation_plan
    @formation_plan = FormationPlan.includes(:formation_modules).find(params[:id])
  end

  def formation_plan_params
    params.require(:formation_plan).permit(:name, formation_module_ids: [])
  end
end
