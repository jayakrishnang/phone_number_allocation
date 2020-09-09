# frozen_string_literal: true

class Api::V1::PhoneNumbersController < Api::V1::ApiController
  def index
    render_collection(PhoneNumber.includes(:user), { name: 'phone_numbers' }, each_serializer: PhoneNumberSerializer)
  end
end
