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
    center_x { 5.0 }
    center_y { 7.5 }
    radius { 2.5 }

    trait :large do
      radius { 10.0 }
    end

    trait :small do
      radius { 0.5 }
    end

    trait :at_origin do
      center_x { 0.0 }
      center_y { 0.0 }
    end
  end
end
