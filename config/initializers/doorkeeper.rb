# frozen_string_literal: true

Doorkeeper.configure do
  orm :active_record

  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  admin_authenticator do
    current_user || warden.authenticate!(scope: :user)
  end

  default_scopes :read
  optional_scopes :write

  enforce_configured_scopes
end
