class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def require_collaborator!
    return if current_person.is_a?(Collaborator)

    head :not_found
  end

  def require_dean!
    return if current_person.is_a?(Dean)

    head :not_found
  end
end
