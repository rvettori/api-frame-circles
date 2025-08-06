# frozen_string_literal: true

class CreateFrames < ActiveRecord::Migration[8.0]
  def change
    create_table :frames do |t|
      t.decimal :center_x, precision: 10, scale: 2, null: false
      t.decimal :center_y, precision: 10, scale: 2, null: false
      t.decimal :height, precision: 10, scale: 2, null: false
      t.decimal :width, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
