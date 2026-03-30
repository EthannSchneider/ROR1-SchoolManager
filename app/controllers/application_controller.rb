class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  before_action :store_index_view_mode
  helper_method :index_view_mode, :can_view_sensitive_person_data?, :pagination_per_page_value, :pagination_per_page_options

  private

  def store_index_view_mode
    return unless params[:view].in?(%w[table cards])

    session[:index_view_mode] = params[:view]
  end

  def index_view_mode
    session[:index_view_mode].in?(%w[table cards]) ? session[:index_view_mode] : "table"
  end

  def can_view_sensitive_person_data?
    current_person.is_a?(Collaborator)
  end

  def require_student!
    return if current_person.is_a?(Student)
    head :forbidden
  end

  def can_access_formation_plan?(formation_plan)
    return true if current_person.is_a?(Dean)
    return true if current_person.is_a?(Collaborator)
    if current_person.is_a?(Student)
      return true if current_person.formation_plan == formation_plan
    end

    false
  end

  def require_formation_plan_access!(formation_plan)
    return true if can_access_formation_plan?(formation_plan)

    head :forbidden
  end

  def require_collaborator!
    return if can_view_sensitive_person_data?

    head :not_found
  end

  def require_dean!
    return if current_person.is_a?(Dean)

    head :not_found
  end

  def pagination_per_page_value(default: 10, max: 100)
    per_page = params[:per_page].to_i
    per_page = default if per_page <= 0
    per_page = max if per_page > max
    per_page
  end

  def pagination_per_page_options
    [ 10, 25, 50, 100 ]
  end
end
