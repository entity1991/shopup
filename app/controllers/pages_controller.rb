class PagesController < ApplicationController

  def home
    @title = "Home"
    @opened_stores = Store.opened
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
    if params[:question]
      MainMailer.help(params[:question], current_user).deliver
      flash[:success] = "Thanks You!"
      redirect_to root_path
    end
  end

end
