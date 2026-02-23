class RootController < ApplicationController
  def index
    if !person_signed_in?
      redirect_to new_person_session_path
    end
  end
end
