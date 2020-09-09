# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :phone_numbers

  def allocate_phone_number(number)
    PhoneNumber.transaction do
      phone_number = PhoneNumber.find_available_number(number)
      self.phone_numbers.create(phone_number: phone_number)
    end
  end
end
