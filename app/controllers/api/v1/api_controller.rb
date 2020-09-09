# frozen_string_literal: true

class Api::V1::ApiController < ActionController::Base
  include Application::ResponseHandler
  include Application::ExceptionHandler
  skip_before_action :verify_authenticity_token
  before_action :doorkeeper_authorize!

  respond_to :html, :json

  def doorkeeper_unauthorized_render_options(error = nil)
    if error[:error].present? && error[:error].reason == :expired
      { json: { message: 'Token has expired' } }
    else
      { json: { message: 'You are not authorized' } }
    end
  end

  protected

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_user
    @current_user ||= current_resource_owner
  end
end
