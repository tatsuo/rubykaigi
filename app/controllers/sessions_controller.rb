class SessionsController < ApplicationController
  layout_for_latest_ruby_kaigi

  protect_from_forgery :except => :create

  def new
  end

  def create
    auth = request.env["omniauth.auth"].symbolize_keys

    if authentication = Authentication.where(:provider => auth[:provider], :uid => auth[:uid]).first
      session[:user_id] = authentication.rubyist_id
      redirect_to session.delete(:return_to) || dashboard_path

    elsif user
      user.authentications.create! :provider => auth[:provider], :uid => auth[:uid]
      flash[:notice] = "アカウントにサービスを紐づけました"
      redirect_to edit_account_path

    else
      if auth[:provider] == 'password'
        flash[:error] = "Authentication error: Invalid username or password"
        redirect_to signin_path
      else
        store_auth_params(auth)
        redirect_to new_account_path
      end
    end
  end

  def destroy
    reset_session
    redirect_to signin_path, :notice => 'You have signed out successfully'
  end

  def failure
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to signin_path
  end

  private

    def store_auth_params(auth)
      paramz = auth.slice(:provider, :uid)
      paramz[:user_info] = auth[:user_info].symbolize_keys.slice(:email, :nickname, :name)
      session[:params_from_authenticator] = paramz
    end
end
