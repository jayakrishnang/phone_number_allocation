# frozen_string_literal: true

class PhoneNumberSerializer < ActiveModel::Serializer
  attributes :id, :phone_number, :user_id, :user_email

  def user_email
    object.user.email
  end
end
