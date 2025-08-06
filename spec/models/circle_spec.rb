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
      let(:circle) { subject }

      it { is_expected.to validate_numericality_of(:radius).is_greater_than(0) }
      it { is_expected.to validate_numericality_of(:center_x).is_greater_than(circle.radius) }
      it { is_expected.to validate_numericality_of(:center_y).is_greater_than(circle.radius) }
    end
  end
end
