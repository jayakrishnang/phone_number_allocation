# frozen_string_literal: true

class PhoneNumber < ApplicationRecord
  belongs_to :user

  validates :phone_number, presence: true, uniqueness: true, length: { is: 10 }

  def self.find_available_number(number)
    loop do
      break unless PhoneNumber.where(phone_number: number).exists?

      number = rand(1111111111..9999999999)
    end
    number
  end
end
