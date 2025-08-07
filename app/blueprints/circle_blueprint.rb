# frozen_string_literal: true

class CircleBlueprint < Blueprinter::Base
  identifier :id

  fields :center_x, :center_y, :radius, :frame_id

  view :basic do
    fields :center_x, :center_y
  end
end
