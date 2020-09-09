# frozen_string_literal: true

FactoryBot.define do
  factory :phone_number, class: PhoneNumber do
    phone_number { rand(1111111111..9999999999) }
  end
end