require 'digest/sha1'

module AuthenticatedSystem
  protected

  def login_required
    authorized? || access_denied
  end

  # Returns true if the user is logged in, false otherwise
  # Preloads @current_user with the user model if they're logged in.
  def logged_in?
    current_user.present?
  end

  def access_denied
    redirect_to root_path, alert: "Please sign in to proceed"
  end

  # Accesses the current user from the session.
  def current_user
    @current_user ||= login_from_session
  end

  # Sign in the user
  #
  # updates the session and sets the current_user
  def sign_in(new_user)
    session['current_user_id'] = new_user.id
    @current_user = nil
    current_user
  end

  # Logout for the user
  #
  # kill session and remember me cookie
  def sign_out
    reset_session
    @current_user = nil
  end

  def authorized?
    logged_in?
  end

  def login_from_session
    current_user_id = session['current_user_id']
    if current_user_id.present?
      User.find_by(id: current_user_id)
    else
      nil
    end
  end

  # Inclusion hook to make #current_user and #logged_in?
  # available as ActionView helper methods.
  def self.included(base)
    base.send :helper_method, :current_user, :logged_in?
  end
end