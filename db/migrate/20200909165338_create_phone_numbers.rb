# frozen_string_literal: true

class CreatePhoneNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :phone_numbers do |t|
      t.references :user, foreign_key: true
      t.string :phone_number, limit: 15

      t.timestamps
    end
  end
end
