class SessionsController < ApplicationController

  before_filter :access_for_create_session, :only => [:new, :create]
  before_filter :authenticate, :only => [:profile]

  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination or you are not activated user."
      @title = "Sign in"
      render "new"
    else
      sign_in user
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def change_locale
    session[:locale] = params[:set_locale]
    redirect_to :back
  end

  def change_editor_theme
    session[:editor_theme] = params[:id]
    render :text => nil, :status => 200
  end

  def change_editor_ln
    session[:editor_ln] = params[:id]
    render :text => nil, :status => 200
  end

  def change_editor_font_size
    session[:editor_font_size] = params[:id]
    render :text => nil, :status => 200
  end


  def join_confirm
    confirm = JoinConfirmation.find_by_activation_code params[:activation_code]
    if confirm
      confirm.destroy
      flash[:success] = "Activation confirm successful. You can enter with you email/pass."
      redirect_to root_path
    end
  end

  private

  def access_for_create_session
    if signed_in?
      redirect_back_or root_path
    end
  end
end
