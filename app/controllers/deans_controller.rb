class DeansController < ApplicationController
  before_action :set_dean, only: :show

  def index
    per_page = pagination_per_page_value
    @deans = Dean.all.page(params[:page]).per(per_page)
    @pagination_per_page = per_page
  end

  def show
  end

  private

  def set_dean
    @dean = Dean.find(params[:id])
  end
end
