# frozen_string_literal: true

# == Schema Information
#
# Table name: circles
#
#  id         :integer          not null, primary key
#  frame_id   :integer          not null
#  center_x   :decimal(10, 2)   not null
#  center_y   :decimal(10, 2)   not null
#  radius     :decimal(10, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_circles_on_frame_id  (frame_id)
#

class Circle < ApplicationRecord
  belongs_to :frame

  validates :center_x, :center_y, :radius, presence: true
  validates :center_x, :center_y, numericality: { greater_than: ->(circle) { circle.radius.to_d } }
  validates :radius, numericality: { greater_than: 0 }
end
