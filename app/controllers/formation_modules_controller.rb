class FormationModulesController < ApplicationController
  before_action :set_formation_module, only: %i[show edit update destroy]
  before_action :set_formation_plan
  before_action :require_dean!, only: %i[new create edit update destroy]

  def index
    head :forbidden unless can_access_formation_plan?(@formation_plan)
  end

  def show
    head :forbidden unless can_access_formation_plan?(@formation_plan)
  end

  def new
    return head :forbidden unless can_access_formation_plan?(@formation_plan)
    @formation_module = FormationModule.new
  end

  def edit
    head :forbidden unless can_access_formation_plan?(@formation_plan)
  end

  def create
    return head :forbidden unless can_access_formation_plan?(@formation_plan)
    @formation_module = FormationModule.new(formation_module_params)
    @formation_module.formation_plans << @formation_plan if @formation_plan

    if @formation_module.save
      redirect_to formation_plan_formation_module_url(@formation_plan, @formation_module), notice: "Module was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return head :forbidden unless can_access_formation_plan?(@formation_plan)
    if @formation_module.update(formation_module_params)
      redirect_to formation_plan_formation_module_url(@formation_plan, @formation_module), notice: "Module was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return head :forbidden unless can_access_formation_plan?(@formation_plan)
    @formation_module.destroy
    redirect_to formation_plan_url(@formation_plan), notice: "Module was successfully destroyed."
  end

  private

  def set_formation_module
    @formation_module = FormationModule.includes(:formation_plans, :unities).find(params[:id])
  end

  def set_formation_plan
    @formation_plan = FormationPlan.find(params[:formation_plan_id]) if params[:formation_plan_id]
  end

  def formation_module_params
    params.require(:formation_module).permit(:name)
  end
end
