module Helpers
  module Authentication
    def sign_in_as(user = nil)
      user ||= create(:user, :test)

      visit "/users/sign_in"
      fill_in "user_login", with: user.username
      fill_in "user_password", with: user.password
      click_button "Submit"

      user
    end

    alias sign_in_default_user sign_in_as
  end
end

RSpec.configure do |config|
  config.include Helpers::Authentication, type: :system
end
