class DeansController < ApplicationController
  before_action :set_dean, only: :show

  def index
    @deans = Dean.order(:lastname, :firstname)
  end

  def show
  end

  private

  def set_dean
    @dean = Dean.find(params[:id])
  end
end
