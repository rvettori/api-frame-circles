# frozen_string_literal: true

class FrameBlueprint < Blueprinter::Base
  identifier :id

  fields :center_x, :center_y

  field :circles_count do |frame|
    frame.circles.count
  end

  field :circle_top_position do |frame|
    position = frame.circle_top_position
    position ? CircleBlueprint.render_as_hash(position, view: :basic) : nil
  end

  field :circle_down_position do |frame|
    position = frame.circle_down_position
    position ? CircleBlueprint.render_as_hash(position, view: :basic) : nil
  end

  field :circle_left_position do |frame|
    position = frame.circle_left_position
    position ? CircleBlueprint.render_as_hash(position, view: :basic) : nil
  end

  field :circle_right_position do |frame|
    position = frame.circle_right_position
    position ? CircleBlueprint.render_as_hash(position, view: :basic) : nil
  end

  view :detailed do
    fields :height, :width
  end
end
