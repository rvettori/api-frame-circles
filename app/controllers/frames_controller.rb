# frozen_string_literal: true

class FramesController < ApplicationController
  before_action :set_frame, only: %i[ show destroy ]

  # GET /frames/1
  def show
    render json: FrameBlueprint.render(@frame)
  end

  # POST /frames
  def create
    @frame = Frame.new(frame_params)

    if @frame.save
      render json: FrameBlueprint.render(@frame, view: :detailed),
             status: :created,
             location: @frame
    else
      render json: @frame.errors, status: :unprocessable_content
    end
  end

  # DELETE /frames/1
  def destroy
    if @frame.destroy
      head :no_content
    else
      render json: @frame.errors, status: :unprocessable_content
    end
  end

  # POST /frames/:id/circles
  def circles
    @frame = Frame.find(params[:id])
    @circle = @frame.circles.build(circle_params)

    if @circle.save
      render json: CircleBlueprint.render(@circle),
             status: :created,
             location: @circle
    else
      render json: @circle.errors, status: :unprocessable_content
    end
  end

  private

    def set_frame
      @frame = Frame.find(params[:id])
    end

    def frame_params
      params.require(:frame).permit(:center_x, :center_y, :height, :width, circles_attributes: [ :center_x, :center_y, :radius ])
    end

    def circle_params
      params.require(:circle).permit(:center_x, :center_y, :radius)
    end
end
