# frozen_string_literal: true

class CirclesController < ApplicationController
  before_action :set_circle, only: %i[ show destroy ]
  before_action :set_frame, only: %i[ create ]

  # GET /frames/:frame_id/circles
  def index
    @frame = Frame.find(params[:frame_id])
    @circles = @frame.circles
    render json: CircleBlueprint.render(@circles)
  end

  # GET /circles/1
  def show
    render json: CircleBlueprint.render(@circle, view: :detailed)
  end

  # POST /frames/:frame_id/circles
  def create
    @circle = @frame.circles.build(circle_params)

    if @circle.save
      render json: CircleBlueprint.render(@circle, view: :detailed),
             status: :created
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
