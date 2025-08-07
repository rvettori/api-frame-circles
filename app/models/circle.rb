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
  validates :center_x, :center_y, numericality: { greater_than_or_equal_to: 0 }
  validates :radius, numericality: { greater_than: 0 }

  validate :validate_circle_inside_frame
  validate :validate_circle_collision

  private

  def distance_between_points(x1, y1, x2, y2)
    Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
  end

  def validate_circle_collision
    return unless frame.present? && center_x.present? && center_y.present? && radius.present?
    existing_circles = frame.circles.where.not(id: id)

    existing_circles.each do |circle|
      distance = distance_between_points(center_x, center_y, circle.center_x, circle.center_y)

      if distance < (radius + circle.radius)
        errors.add(:base, "Circle collides with existing circle at (#{circle.center_x}, #{circle.center_y})")
      end
    end
  end

  def validate_circle_inside_frame
    return unless frame.present? && center_x.present? && center_y.present? && radius.present?

    unless center_x - radius >= frame.min_x &&
           center_x + radius <= frame.max_x &&
           center_y - radius >= frame.min_y &&
           center_y + radius <= frame.max_y
      errors.add(:base, "Circle must be completely within the frame")
    end
  end
end
