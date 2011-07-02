class AuthenticationsController < ApplicationController
  before_filter :login_required, :only => %w(destroy)

  def destroy
    if user.multi_account?
      authentication = user.authentications.where(:id => params[:id]).last
      authentication.destroy
    end

    redirect_to edit_account_path
  end
end
