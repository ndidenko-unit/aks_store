class ApplicationController < ActionController::Base

  before_action :set_paper_trail_whodunnit

  def blocked_user!
    if current_user.role == "block"
      sign_out
      redirect_to request.referrer, notice: 'Ваша учетная запись заблокирована'
    end
  end

  def only_for_admin!
    if current_user.role == "seller"
      redirect_to request.referrer, notice: 'У вас нет прав администратора'
    end
  end

end
