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

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:circles) }
  end

  describe 'validations' do
    subject { build(:frame) }

    context 'when presence validations' do
      it { is_expected.to validate_presence_of(:center_x) }
      it { is_expected.to validate_presence_of(:center_y) }
      it { is_expected.to validate_presence_of(:height) }
      it { is_expected.to validate_presence_of(:width) }
    end

    context 'when numericality validations' do
      let(:frame) { subject }

      it { is_expected.to validate_numericality_of(:height).is_greater_than(0) }
      it { is_expected.to validate_numericality_of(:width).is_greater_than(0) }
      it { is_expected.to validate_numericality_of(:center_x).is_greater_than_or_equal_to(frame.width / 2) }
      it { is_expected.to validate_numericality_of(:center_y).is_greater_than_or_equal_to(frame.height / 2) }
    end

    context 'when frame must be in first quadrant' do
      it 'validates frame is completely in first quadrant' do
        frame = build(:frame, center_x: 5.0, center_y: 5.0, width: 12.0, height: 12.0)

        expect(frame).not_to be_valid
        expect(frame.errors[:base]).to include('Frame must be in the first quadrant (x, y >= 0)')
      end

      it 'allows frame at origin boundary' do
        frame = build(:frame, center_x: 10.0, center_y: 10.0, width: 20.0, height: 20.0)

        expect(frame).to be_valid
      end
    end
  end

  describe 'before destroy' do
    let! (:frame_with_circles) { create(:frame, :with_circles) }
    let! (:frame) { create(:frame) }

    it 'prevents destruction when frame has associated circles' do
      expect { frame_with_circles.destroy }.not_to change(described_class, :count)
    end

    it 'raises error when using destroy! with associated circles' do
      expect { frame_with_circles.destroy! }.to raise_error(ActiveRecord::RecordNotDestroyed)
    end

    it 'allows destruction when frame has no circles' do
      expect { frame.destroy }.to change(described_class, :count).by(-1)
    end
  end

  describe 'instance methods' do
    let(:frame) { create(:frame, center_x: 15.0, center_y: 10.0, width: 20.0, height: 12.0) }

    describe '#min_x' do
      it 'returns the minimum x coordinate of the frame' do
        expect(frame.min_x).to eq(5.0)
      end
    end

    describe '#max_x' do
      it 'returns the maximum x coordinate of the frame' do
        expect(frame.max_x).to eq(25.0)
      end
    end

    describe '#min_y' do
      it 'returns the minimum y coordinate of the frame' do
        expect(frame.min_y).to eq(4.0)
      end
    end

    describe '#max_y' do
      it 'returns the maximum y coordinate of the frame' do
        expect(frame.max_y).to eq(16.0)
      end
    end

    describe '#circle_top_position' do
      context 'when frame has circles' do
        before do
          create(:circle, frame: frame, center_x: 10.0, center_y: 8.0)
          create(:circle, frame: frame, center_x: 20.0, center_y: 10.0)
        end

        let!(:circle_top) { create(:circle, frame: frame, center_x: 15.0, center_y: 12.0) }

        it 'returns the circle with the highest y coordinate' do
          expect(frame.circle_top_position).to eq(circle_top)
        end
      end

      context 'when frame has no circles' do
        it 'returns nil' do
          expect(frame.circle_top_position).to be_nil
        end
      end
    end

    describe '#circle_down_position' do
      context 'when frame has circles' do
        before do
          create(:circle, frame: frame, center_x: 15.0, center_y: 12.0)
          create(:circle, frame: frame, center_x: 20.0, center_y: 10.0)
        end

        let!(:circle_down) { create(:circle, frame: frame, center_x: 10.0, center_y: 8.0) }

        it 'returns the circle with the lowest y coordinate' do
          expect(frame.circle_down_position).to eq(circle_down)
        end
      end

      context 'when frame has no circles' do
        it 'returns nil' do
          expect(frame.circle_down_position).to be_nil
        end
      end
    end

    describe '#circle_left_position' do
      context 'when frame has circles' do
        before do
          create(:circle, frame: frame, center_x: 15.0, center_y: 12.0)
          create(:circle, frame: frame, center_x: 20.0, center_y: 10.0)
        end

      let!(:circle_left) { create(:circle, frame: frame, center_x: 8.0, center_y: 10.0) }

        it 'returns the circle with the lowest x coordinate' do
          expect(frame.circle_left_position).to eq(circle_left)
        end
      end

      context 'when frame has no circles' do
        it 'returns nil' do
          expect(frame.circle_left_position).to be_nil
        end
      end
    end

    describe '#circle_right_position' do
      context 'when frame has circles' do
        before do
          create(:circle, frame: frame, center_x: 8.0, center_y: 10.0)
          create(:circle, frame: frame, center_x: 15.0, center_y: 12.0)
        end

        let!(:circle_right) { create(:circle, frame: frame, center_x: 22.0, center_y: 10.0) }

        it 'returns the circle with the highest x coordinate' do
          expect(frame.circle_right_position).to eq(circle_right)
        end
      end

      context 'when frame has no circles' do
        it 'returns nil' do
          expect(frame.circle_right_position).to be_nil
        end
      end
    end
  end
end
