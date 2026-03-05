class People::ProfilePicturesController < ApplicationController
  def update
    picture = profile_picture_params[:profile_picture]

    if picture.present? && current_person.update(profile_picture: picture)
      redirect_back fallback_location: polymorphic_path(current_person), notice: "Profile picture was successfully updated."
    else
      redirect_back fallback_location: polymorphic_path(current_person), alert: "Profile picture could not be updated."
    end
  end

  private

  def profile_picture_params
    params.require(:person).permit(:profile_picture)
  end
end
