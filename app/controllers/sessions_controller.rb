class SessionsController < Website::ApplicationController  
  def create
    user = User.find_by(github_uid: auth['uid']) || User.create_with_omniauth(auth)
    if user
      sign_in(user)
      redirect_to dashboard_path
    else
      redirect_to :back, alert: "Could not perform login"
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: 'Signed out!'
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
