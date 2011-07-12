class AccountsController < ApplicationController
  verify :session => :params_from_authenticator, :only => %w(new create), :redirect_to => :signin_path
  before_filter :check_if_smartphone

  layout_for_latest_ruby_kaigi

  def new
    @rubyist = Rubyist.new_with_omniauth(session[:params_from_authenticator])
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end

  def create
    @rubyist = Rubyist.new_with_omniauth(session[:params_from_authenticator])
    @rubyist.attributes = params[:rubyist]

    if @rubyist.save
      session[:user_id] = @rubyist.id
      session.delete(:params_from_authenticator)

      redirect_to session.delete(:return_to) || root_path
    else
      render :new
    end
  end

  before_filter :login_required, :only => %w(edit update)

  def edit
    @rubyist = user
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end

  def update
    password_auth = user.password_authentication

    Rubyist.transaction do
      user.update_attributes! params[:rubyist]

      if password_auth && params[:password]
        password_auth.change_password! params.slice(:current_password, :password, :password_confirmation)
      end

      redirect_to edit_account_path, :notice => 'Your settings have been saved.'
    end
  rescue ActiveRecord::RecordInvalid
    @rubyist = user
    @rubyist.errors.merge! password_auth.errors if password_auth
    render :edit
  end
end
