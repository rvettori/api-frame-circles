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
    center_y { 15.0 }
    height { 20.0 }
    width { 20.0 }

    trait :with_circles do
      after(:create) do |frame|
        create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0)
        create(:circle, frame: frame, center_x: 20.0, center_y: 20.0, radius: 2.0)
        create(:circle, frame: frame, center_x: 15.0, center_y: 7.0, radius: 1.5)
      end
    end
  end
end
