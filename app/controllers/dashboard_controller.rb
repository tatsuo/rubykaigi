class DashboardController < LocaleBaseController
  before_filter :login_required
  before_filter :check_if_smartphone

  layout_for_latest_ruby_kaigi

  def index
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end
end
