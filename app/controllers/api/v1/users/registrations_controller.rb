# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  include Application::ExceptionHandler
  skip_before_action :verify_authenticity_token

  def create
    build_resource(sign_up_params)
    if resource.save
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
          access_token = Doorkeeper::AccessToken.create!(application_id: nil, resource_owner_id: resource.id)
        else
          expire_data_after_sign_in!
        end
        # resource.notify_activity('sign_up')
        render status: :ok, json: {
          message: I18n.t('devise.registrations.signed_up'),
          data: { access_token: access_token.token, created_at: access_token.created_at,
                  token_type: 'bearer', result: ActiveModelSerializers::SerializableResource.new(resource) }
        }
      else
        render_error I18n.t('api.unsuccessful')
      end
    elsif resource.errors.messages[:email] == ['has already been taken']
      render_error I18n.t('api.users.existing_user')
    else
      render_error resource.errors
    end
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
