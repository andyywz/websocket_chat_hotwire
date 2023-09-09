class ApplicationController < ActionController::Base
  add_flash_types :info, :warning
  before_action :authenticate_user!
end
