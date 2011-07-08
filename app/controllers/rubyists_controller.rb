class RubyistsController < LocaleBaseController
  before_filter :check_if_smartphone
  layout_for_latest_ruby_kaigi

  def show
    @rubyist = Rubyist.find_by_username(params[:id])
    unless @rubyist
      render :status => '404', :file => 'public/404.html', :layout => false
    end
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end
end
