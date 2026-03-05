require "test_helper"

class People::ProfilePicturesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    uniq = SecureRandom.hex(4)

    @collaborator = Collaborator.create!(
      email: "collaborator-#{uniq}@example.com",
      firstname: "Alice",
      lastname: "Martin",
      avs_number: "756.3333.4444.#{rand(10_000..99_999)}",
      contract_start: Date.today,
      contract_end: Date.today + 365,
      password: "password123"
    )
  end

  test "signed in person can update their profile picture" do
    sign_in @collaborator

    file = Rack::Test::UploadedFile.new(Rails.root.join("app/assets/images/school.jpeg"), "image/jpeg")

    patch profile_picture_url, params: { person: { profile_picture: file } }

    assert_redirected_to collaborator_url(@collaborator)
    assert @collaborator.reload.profile_picture.attached?
  end

  test "guest cannot update profile picture" do
    file = Rack::Test::UploadedFile.new(Rails.root.join("app/assets/images/school.jpeg"), "image/jpeg")

    patch profile_picture_url, params: { person: { profile_picture: file } }

    assert_redirected_to new_person_session_url
  end
end
