class DeviseExtensions::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(user_params)
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  protected
  def after_update_path_for(resource)
    edit_user_registration_path
  end

  private
  def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, 
                                   :name, :avatar, :retained_avatar, :remove_avatar,
                                   :show_location_data, :show_nsfw_content, 
                                   :default_license_id)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation) }
  end
end