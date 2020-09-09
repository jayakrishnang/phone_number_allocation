# frozen_string_literal: true

module Application::ExceptionHandler
  extend ActiveSupport::Concern

  def render_not_found(exception)
    render json: {
      message: "#{exception.model.constantize} #{I18n.t('not_found')}"
    }, status: '404'
  end

  def render_error(errors)
    render json: {
      message: errors
    }, status: :unprocessable_entity
  end
end
