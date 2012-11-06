class ApplicationController < ActionController::Base

  before_filter :set_i18n_locale_from_session

  protect_from_forgery

  include ApplicationHelper
  include SessionsHelper

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
