class UnitiesController < ApplicationController
  before_action :set_unity, only: %i[show edit update destroy]
  before_action :set_formation_module, only: %i[index show new create edit update destroy]
  before_action :set_formation_modules_for_select, only: %i[new create edit]
  before_action :require_dean!, only: %i[new create edit update destroy]

  def index
    per_page = pagination_per_page_value
    if params[:formation_module_id]
      @formation_module = FormationModule.find(params[:formation_module_id])
      @unities = @formation_module.unities.page(params[:page]).per(per_page)
    else
      @unities = Unity.includes(:formation_module).page(params[:page]).per(per_page)
    end
    @pagination_per_page = per_page
  end

  def show
  end

  def new
    @unity = Unity.new
  end

  def edit
  end

  def create
    @unity = Unity.new(unity_params)
    @unity.formation_module = @formation_module if @formation_module

    if @unity.save
      redirect_to formation_module_unity_url(@formation_module, @unity), notice: "Unity was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @unity.update(unity_params)
      if @formation_module
        redirect_to formation_module_unity_url(@formation_module, @unity), notice: "Unity was successfully updated."
      else
        redirect_to unity_url(@unity), notice: "Unity was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @unity.destroy
    redirect_to formation_module_unities_url(params[:formation_module_id]), notice: "Unity was successfully destroyed."
  end

  private

  def set_unity
    @unity = Unity.includes(:formation_module).find(params[:id])
  end

  def set_formation_module
    @formation_module = FormationModule.find(params[:formation_module_id]) if params[:formation_module_id]
  end

  def set_formation_modules_for_select
    @formation_modules = FormationModule.order(:name)
  end

  def unity_params
    params.require(:unity).permit(:name, :formation_module_id)
  end
end
