# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::ApiController
  def me
    render_object(current_user, { name: 'user' }, serializer: UserSerializer)
  end

  def allocate_phone_number
    phone_number = current_user.allocate_phone_number(params[:phone_number])
    if phone_number.new_record?
      render_error(phone_number.errors)
    else
      message = phone_number.phone_number == params[:phone_number] ? 'Available and allocated' : 'Not Available. New number allocated'
      render json: { phone_number: phone_number.phone_number, message: message }
    end
  end
end
