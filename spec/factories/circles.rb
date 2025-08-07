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

# frozen_string_literal: true

FactoryBot.define do
  factory :circle do
    association :frame
    center_x { 10.0 }
    center_y { 10.0 }
    radius { 2.0 }
  end
end
