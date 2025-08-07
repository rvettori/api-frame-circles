# frozen_string_literal: true

class CirclesController < ApplicationController
  before_action :set_circle, only: %i[ update destroy ]

  # GET /frames/:frame_id/circles
  def index
    if params[:center_x].present? && params[:center_y].present? && params[:radius].present? && params[:frame_id].present?
      center_x = params[:center_x].to_f
      center_y = params[:center_y].to_f
      radius = params[:radius].to_f
      frame_id = params[:frame_id].to_i

      @circles = Circle.within_circle(center_x, center_y, radius, frame_id)

      render json: CircleBlueprint.render(@circles)
    else
      render json: []
    end
  end

  # PATCH/PUT /circles/1
  def update
    if @circle.update(circle_params)
      render json: CircleBlueprint.render(@circle)
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  # DELETE /circles/1
  def destroy
    @circle.destroy!
    head :no_content
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def set_frame
    @frame = Frame.find(params[:frame_id])
  end

  def circle_params
    params.require(:circle).permit(:center_x, :center_y, :radius)
  end
end
