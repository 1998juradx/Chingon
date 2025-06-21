ActiveAdmin.setup do |config|
  config.site_title = "Chingon"

  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user

  config.logout_link_path = :destroy_admin_user_session_path

  config.filter_attributes = [:encrypted_password, :password, :password_confirmation]

  config.comments = false
  config.comments_menu = false
end