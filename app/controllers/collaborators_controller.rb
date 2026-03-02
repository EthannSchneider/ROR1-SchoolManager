class CollaboratorsController < ApplicationController
  before_action :set_collaborator, only: %i[show edit update destroy]
  before_action :require_dean!, only: %i[new create edit update destroy]

  def index
    @collaborators = Collaborator.order(:lastname, :firstname)
  end

  def show
  end

  def new
    @collaborator = Collaborator.new
  end

  def edit
  end

  def create
    @collaborator = Collaborator.new(collaborator_params)

    if @collaborator.save
      redirect_to collaborator_url(@collaborator), notice: "Collaborator was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @collaborator.update(collaborator_params)
      redirect_to collaborator_url(@collaborator), notice: "Collaborator was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @collaborator.destroy
    redirect_to collaborators_url, notice: "Collaborator was successfully destroyed."
  end

  private

  def set_collaborator
    @collaborator = Collaborator.find(params[:id])
  end

  def collaborator_params
    permitted = params.require(:collaborator).permit(
      :firstname,
      :lastname,
      :email,
      :avs_number,
      :contract_start,
      :contract_end,
      :password,
      :type
    )

    if permitted[:type].present? && !allowed_collaborator_types.include?(permitted[:type])
      permitted[:type] = "Collaborator"
    end

    permitted.delete(:password) if permitted[:password].blank?
    permitted
  end

  def allowed_collaborator_types
    %w[Collaborator Teacher Dean]
  end
end
