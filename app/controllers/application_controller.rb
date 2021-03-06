class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    render file: "#{Rails.root}/public/403.html", status: 403
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :remember_me)
    end

    devise_parameter_sanitizer.for(:sign_in) do |u|
      u.permit(:login, :username, :email, :password, :remember_me)
    end

    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:username, :email, :password, :password_confirmation, :current_password)
    end
  end

  def ability_to_array(a)
    a.instance_variable_get("@rules").collect do |rule| 
      rule.instance_eval do
        {
          base_behavior: @base_behavior,
          subjects: @subjects.map {|x| x.to_json(only: :author_id) },
          actions: @actions.map(&:to_s),
          conditions: @conditions
        }
      end
    end
  end

end
