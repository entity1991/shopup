class ApplicationController < ActionController::Base

  TEMPORARY_EMPTY_FILE_PATH = "./temp/temporary_clear_file_for_paperclip.txt"

  before_filter :set_i18n_locale_from_session

  protect_from_forgery

  include ApplicationHelper
  include SessionsHelper

  private

  def current_cart
    Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    cart = Cart.create
    session[:cart_id] = cart.id
    cart
  end

  protected

  def set_i18n_locale_from_session
    if session[:locale]
      if I18n.available_locales.include?(session[:locale].to_sym)
        I18n.locale = session[:locale]
      else
        flash.now[:notice] = session[:locale] + " translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

end
