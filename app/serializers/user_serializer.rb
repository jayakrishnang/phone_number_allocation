# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :phone_numbers

  def phone_numbers
    object.phone_numbers.pluck(:phone_number)
  end
end
