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
  has_many :circles

  validates :center_x, :center_y, :height, :width, presence: true
  validates :center_x, numericality: { greater_than_or_equal_to: ->(frame) { frame.width.to_d } }
  validates :center_y, numericality: { greater_than_or_equal_to: ->(frame) { frame.height.to_d } }
  validates :height, :width, numericality: { greater_than: 0 }, if: -> { height.present? && width.present? }

  before_destroy :check_for_circles

  private

  def check_for_circles
    return unless circles.exists?

    errors.add(:base, "Não é possível excluir o frame pois existem círculos associados")
    throw(:abort)
  end
end
