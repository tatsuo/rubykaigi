class TicketsController < ApplicationController
  before_filter :login_required, :only => [:index, :regenerate_permalink]
  before_filter :check_if_smartphone

  layout_for_latest_ruby_kaigi

  def index
    I18n.locale = 'en'
    @tickets = user.tickets_of(RubyKaigi.latest_year)
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end

  def edit
    @ticket = Ticket.find_by_code4url(params[:id])
#     unless @ticket.rubyist == user
#       render :status => '403', :file => 'public/403.html'
#       return
#     end
    unless @ticket
      render :status => '404', :file => 'public/404.html', :layout => false
      return
    end
    @title = "[Edit] #{@ticket.ticket_code}, #{I18n.t(@ticket.ticket_type)}"
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end

  def update
    @ticket = Ticket.find_by_code4url(params[:id])
#     unless @ticket.rubyist == user
#       render :status => '403', :file => 'public/403.html'
#       return
#     end
    unless @ticket
      render :status => '404', :file => 'public/404.html', :layout => false
      return
    end
    @ticket.name = params[:ticket][:name]
    @ticket.email = params[:ticket][:email]
    if @ticket.save
      flash[:notice] = 'Your ticket have been updated.'
      redirect_to ticket_path(@ticket)
    else
      if smartphone?
        render :edit, :layout => "ruby_kaigi2011_phone"
      else  
        render :edit
      end
    end
  end

  def show
    I18n.locale = 'en'
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket
      render :status => '404', :file => 'public/404.html', :layout => false
      return
    end
    unless @ticket.ruby_kaigi == RubyKaigi.latest
      render :status => '403', :file => 'public/403.html', :layout => false
      return
    end
    @title = "#{@ticket.ticket_code}, #{I18n.t(@ticket.ticket_type)}"
    render :layout => "ruby_kaigi2011_phone" if smartphone?
  end

  def regenerate_permalink
    @ticket = Ticket.find_by_code4url(params[:id])
    unless @ticket
      render :status => '404', :file => 'public/404.html', :layout => false
    end
    @ticket.update_attribute(:code4url, Ticket.generate_code4url)
    redirect_to ticket_path(@ticket)
  end
end
