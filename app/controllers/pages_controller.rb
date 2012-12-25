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
    @question = Question.new
    @title = "Help"
  end

end
