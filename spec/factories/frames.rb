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

# frozen_string_literal: true

FactoryBot.define do
  factory :frame do
    center_x { 15.0 }
    center_y { 20.0 }
    height { 10.0 }
    width { 12.0 }

    trait :with_circles do
      after(:create) do |frame|
        create_list(:circle, 3, frame: frame)
      end
    end
  end
end
