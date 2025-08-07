# frozen_string_literal: true

# == Schema Information
#
# Table name: frames
#
#  id         :integer          not null, primary key
#  center_x   :decimal(10, 2)   not null
#  center_y   :decimal(10, 2)   not null
#  height     :decimal(10, 2)   not null
#  width      :decimal(10, 2)   not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Frame < ApplicationRecord
  has_many :circles, dependent: :restrict_with_error
  accepts_nested_attributes_for :circles

  validates :center_x, :center_y, :height, :width, presence: true
  validates :center_x, numericality: { greater_than_or_equal_to: ->(frame) { frame.width.to_f / 2 } }
  validates :center_y, numericality: { greater_than_or_equal_to: ->(frame) { frame.height.to_f / 2 } }
  validates :height, :width, numericality: { greater_than: 0 }, if: -> { height.present? && width.present? }

  validate :frame_in_first_quadrant

  before_destroy :check_for_circles

  def min_x
    center_x.to_f - (width.to_f / 2.0)
  end

  def max_x
    center_x.to_f + (width.to_f / 2.0)
  end

  def min_y
    center_y.to_f - (height.to_f / 2.0)
  end

  def max_y
    center_y.to_f + (height.to_f / 2.0)
  end

  def circle_top_position
    center_y = circles.maximum(:center_y)
    circles.find_by(center_y: center_y)
  end

  def circle_down_position
    center_y = circles.minimum(:center_y)
    circles.find_by(center_y: center_y)
  end

  def circle_left_position
    center_x = circles.minimum(:center_x)
    circles.find_by(center_x: center_x)
  end

  def circle_right_position
    center_x = circles.maximum(:center_x)
    circles.find_by(center_x: center_x)
  end

  private


  def frame_in_first_quadrant
    return unless center_x.present? && center_y.present? && width.present? && height.present?

    unless self.min_x >= 0 && self.min_y >= 0
      errors.add(:base, "Frame must be in the first quadrant (x, y >= 0)")
    end
  end

  def check_for_circles
    return unless circles.exists?

    errors.add(:base, "remove circles before deleting frame")
    throw(:abort)
  end
end
