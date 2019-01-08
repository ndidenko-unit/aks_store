class ApplicationController < ActionController::Base

  def blocked_user!
    if current_user.role == "block"
      sign_out
      redirect_to root_path, notice: 'Ваша учетная запись заблокирована'
    end
  end

end
