# frozen_string_literal: true

require 'swagger_helper'

# rubocop:disable RSpec/EmptyExampleGroup
RSpec.describe 'frames', type: :request do
  path '/frames/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Frame ID'

    get('show frame') do
      tags 'Frames'
      description 'Retrieves a specific frame by ID'
      produces 'application/json'
      consumes 'application/json'

      response(200, 'successful with circles') do
        schema "$ref": "#/components/schemas/frame_response"

        let(:frame) { create(:frame, :with_circles) }
        let(:id) { frame.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['id']).to eq(frame.id)
          expect(data['center_x']).to eq(frame.center_x.to_s)
          expect(data['center_y']).to eq(frame.center_y.to_s)
          expect(data['circles_count']).to eq(3)
          expect(data['circle_top_position']).to be_present
          expect(data['circle_down_position']).to be_present
          expect(data['circle_left_position']).to be_present
          expect(data['circle_right_position']).to be_present
        end
      end

      response(404, 'not found') do
        schema "$ref": "#/components/schemas/not_found_response"

        let(:id) { 999999 }

        run_test! do |response|
          expect(response.status).to eq(404)
        end
      end
    end

    delete('destroy frame') do
      tags 'Frames'
      description 'Deletes a specific frame by ID'
      produces 'application/json'
      consumes 'application/json'

      response(204, 'successful deletion') do
        let(:frame) { create(:frame) }
        let(:id) { frame.id }

        run_test! do |response|
          expect(response.status).to eq(204)
          expect(response.body).to be_empty
          expect(Frame).not_to exist(frame.id)
        end
      end

      response(422, 'unprocessable entity - frame has circles') do
        schema "$ref": "#/components/schemas/frame_destroy_error_response"

        let(:frame) { create(:frame, :with_circles) }
        let(:id) { frame.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(data['base']).to include('Cannot delete record because dependent circles exist')
          expect(Frame).to exist(frame.id)
        end
      end

      response(404, 'not found') do
        schema "$ref": "#/components/schemas/not_found_response"

        let(:id) { 999999 }

        run_test! do |response|
          expect(response.status).to eq(404)
        end
      end
    end
  end

  path '/frames' do
    post('create frame') do
      tags 'Frames'
      description 'Creates a new frame'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :frame, in: :body, schema: {
        "$ref": "#/components/schemas/frame_create_request"
      }

      response(201, 'successful creation') do
        schema "$ref": "#/components/schemas/frame_create_response"

        let(:frame) do
          {
            frame: {
              center_x: 15.0,
              center_y: 15.0,
              height: 20.0,
              width: 20.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['center_x']).to eq('15.0')
          expect(data['center_y']).to eq('15.0')
          expect(data['circles_count']).to eq(0)
          expect(data['circle_top_position']).to be_nil
          expect(data['circle_down_position']).to be_nil
          expect(data['circle_left_position']).to be_nil
          expect(data['circle_right_position']).to be_nil
        end
      end

      response(201, 'successful creation with circles') do
        schema "$ref": "#/components/schemas/frame_create_response"

        let(:frame) do
          {
            frame: {
              center_x: 15.0,
              center_y: 15.0,
              height: 20.0,
              width: 20.0,
              circles_attributes: [
                {
                  center_x: 10.0,
                  center_y: 10.0,
                  radius: 2.0
                },
                {
                  center_x: 20.0,
                  center_y: 20.0,
                  radius: 1.5
                }
              ]
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['center_x']).to eq('15.0')
          expect(data['center_y']).to eq('15.0')
          expect(data['circles_count']).to eq(2)
          expect(data['circle_top_position']).to be_present
          expect(data['circle_down_position']).to be_present
          expect(data['circle_left_position']).to be_present
          expect(data['circle_right_position']).to be_present
        end
      end

      response(422, 'unprocessable entity - validation errors') do
        schema "$ref": "#/components/schemas/frame_create_error_response"

        let(:frame) do
          {
            frame: {
              center_x: 15.0,
              center_y: 15.0,
              height: 20.0,
              width: 20.0,
              circles_attributes: [
                {
                  center_x: 30.0,  # Outside frame bounds
                  center_y: 30.0,  # Outside frame bounds
                  radius: 2.0
                }
              ]
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(422)
          expect(data).to have_key('circles.base')
        end
      end
    end
  end

  path '/frames/{id}/circles' do
    parameter name: 'id', in: :path, type: :integer, description: 'Frame ID'

    post('create circle for frame') do
      tags 'Frames'
      description 'Creates a new circle for a specific frame'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          circle: {
            type: :object,
            properties: {
              center_x: { type: :number, format: :float, description: 'X coordinate of circle center' },
              center_y: { type: :number, format: :float, description: 'Y coordinate of circle center' },
              radius: { type: :number, format: :float, description: 'Circle radius' }
            },
            required: [ 'center_x', 'center_y', 'radius' ]
          }
        },
        required: [ 'circle' ]
      }

      response(201, 'successful circle creation') do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 center_x: { type: :string },
                 center_y: { type: :string },
                 radius: { type: :string },
                 frame_id: { type: :integer }
               }

        let(:frame) { create(:frame) }
        let(:id) { frame.id }
        let(:circle) do
          {
            circle: {
              center_x: 12.0,
              center_y: 12.0,
              radius: 2.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(201)
          expect(data['center_x']).to eq('12.0')
          expect(data['center_y']).to eq('12.0')
          expect(data['radius']).to eq('2.0')
          expect(data['frame_id']).to eq(frame.id)

          # Verifica se o círculo foi realmente associado ao frame
          expect(frame.circles.count).to eq(1)
          expect(frame.circles.first.center_x).to eq(12.0)
        end
      end

      response(422, 'unprocessable entity - validation errors') do
        schema type: :object,
               properties: {
                 center_x: { type: :array, items: { type: :string } },
                 center_y: { type: :array, items: { type: :string } },
                 radius: { type: :array, items: { type: :string } },
                 base: { type: :array, items: { type: :string } }
               }


        context 'with circle outside frame bounds' do
          let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, height: 20.0, width: 20.0) }
          let(:id) { frame.id }
          let(:circle) do
            {
              circle: {
                center_x: 30.0,  # Outside frame bounds
                center_y: 30.0,  # Outside frame bounds
                radius: 2.0
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(data['base']).to be_present
          end
        end
      end

      response(404, 'frame not found') do
        schema type: :object,
               properties: {
                 error: { type: :string }
               }

        let(:id) { 999999 }
        let(:circle) do
          {
            circle: {
              center_x: 12.0,
              center_y: 12.0,
              radius: 2.0
            }
          }
        end

        run_test! do |response|
          expect(response.status).to eq(404)
        end
      end
    end
  end
end
