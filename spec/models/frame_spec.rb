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
      it { is_expected.to validate_numericality_of(:center_x).is_greater_than_or_equal_to(frame.width) }
      it { is_expected.to validate_numericality_of(:center_y).is_greater_than_or_equal_to(frame.height) }
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
end
