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

require 'rails_helper'

RSpec.describe Circle, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:frame) }
  end

  describe 'validations' do
    subject { build(:circle) }

    context 'when presence validations' do
      it { is_expected.to validate_presence_of(:center_x) }
      it { is_expected.to validate_presence_of(:center_y) }
      it { is_expected.to validate_presence_of(:radius) }
    end

    context 'when numericality validations' do
      it { is_expected.to validate_numericality_of(:radius).is_greater_than(0) }
      it { is_expected.to validate_numericality_of(:center_x).is_greater_than_or_equal_to(0) }
      it { is_expected.to validate_numericality_of(:center_y).is_greater_than_or_equal_to(0) }
    end

    context 'when validating geometry constraints' do
      let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 20.0, height: 20.0) }

      it 'validates circle is within frame bounds' do
        circle = build(:circle, frame: frame, center_x: 4.0, center_y: 10.0, radius: 2.0)

        expect(circle).not_to be_valid
        expect(circle.errors[:base]).to include('Circle must be completely within the frame')
      end

      it 'Validates if the circle does not collide with existing circles' do
        create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0)

        circle = build(:circle, frame: frame, center_x: 11.0, center_y: 10.0, radius: 2.0)

        expect(circle).not_to be_valid
        expect(circle.errors[:base]).to include(/Circle collides with existing circle/)
      end

      it 'allows valid circle placement' do
        circle = build(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0)

        expect(circle).to be_valid
      end
    end
  end
end
