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

  describe 'scopes' do
    describe '.within_circle' do
      let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }

      let!(:circle_close_inside) { create(:circle, frame: frame, center_x: 14.0, center_y: 14.0, radius: 1.0) }
      let!(:circle_far_inside) { create(:circle, frame: frame, center_x: 18.0, center_y: 18.0, radius: 1.5) }
      let!(:circle_outside) { create(:circle, frame: frame, center_x: 8.0, center_y: 8.0, radius: 1.0) }
      let!(:circle_different_frame) { create(:circle, center_x: 14.0, center_y: 14.0, radius: 1.0) }

      context 'when searching for circles within a large circle' do
        let(:search_circle) { build(:circle, center_x: 15.0, center_y: 15.0, radius: 6.0) }

        it 'returns circles that are completely within the search circle' do # rubocop:disable RSpec/MultipleExpectations
          result = described_class.within_circle(search_circle.center_x, search_circle.center_y, search_circle.radius, frame.id)

          expect(result).to include(circle_close_inside)
          expect(result).to include(circle_far_inside)
          expect(result).not_to include(circle_outside)
          expect(result).not_to include(circle_different_frame)
        end
      end

      context 'when searching for circles within a small circle' do
        let(:search_circle_x) { 14.0 }
        let(:search_circle_y) { 14.0 }
        let(:search_circle_radius) { 2.0 }

        it 'returns only circles that fit completely within the small search circle' do # rubocop:disable RSpec/MultipleExpectations
          result = described_class.within_circle(search_circle_x, search_circle_y, search_circle_radius, frame.id)

          expect(result).to include(circle_close_inside)
          expect(result).not_to include(circle_far_inside)
          expect(result).not_to include(circle_outside)
          expect(result).not_to include(circle_different_frame)
        end
      end

      context 'when no circles exist in the frame' do
        let(:empty_frame) { create(:frame, center_x: 50.0, center_y: 50.0, width: 30.0, height: 30.0) }

        it 'returns empty result' do
          result = described_class.within_circle(50.0, 50.0, 10.0, empty_frame.id)

          expect(result).to be_empty
        end
      end
    end
  end
end
