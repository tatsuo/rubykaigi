class AuthenticationsController < ApplicationController
  before_filter :login_required, :only => %w(destroy)

  def destroy
    authentication = user.authentications.where(:id => params[:id]).last
    authentication.destroy
    redirect_to edit_account_path
  end
end
