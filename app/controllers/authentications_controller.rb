class AuthenticationsController < ApplicationController
  before_filter :login_required, :only => %w(destroy)

  def destroy
    if user.multi_account?
      authentication = user.authentications.find(params[:id])
      authentication.destroy
    end

    redirect_to edit_account_path
  end
end
