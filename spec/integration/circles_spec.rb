# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'circles', type: :request do
  path '/circles' do
    get('list circles within a search circle') do
      tags 'Circles'
      description 'Returns circles that are completely within the specified search circle'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :center_x, in: :query, type: :number, description: 'X coordinate of search circle center', required: true
      parameter name: :center_y, in: :query, type: :number, description: 'Y coordinate of search circle center', required: true
      parameter name: :radius, in: :query, type: :number, description: 'Radius of search circle', required: true
      parameter name: :frame_id, in: :query, type: :integer, description: 'ID of the frame to search within', required: true

      response(200, 'successful - circles found within search area') do
        schema "$ref": "#/components/schemas/circles_within_response"

        let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
        let!(:circle_inside) { create(:circle, frame: frame, center_x: 14.0, center_y: 14.0, radius: 1.0) }
        let(:circle_outside) { create(:circle, frame: frame, center_x: 8.0, center_y: 8.0, radius: 1.0) }

        let(:center_x) { 15.0 }
        let(:center_y) { 15.0 }
        let(:radius) { 6.0 }
        let(:frame_id) { frame.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(200)
          expect(data).to be_an(Array)
          expect(data.length).to eq(1)
          expect(data.first['id']).to eq(circle_inside.id)
          expect(data.first['center_x']).to eq('14.0')
          expect(data.first['center_y']).to eq('14.0')
          expect(data.first['radius']).to eq('1.0')
          expect(data.first['frame_id']).to eq(frame.id)
        end
      end

      response(200, 'successful - no circles found within search area') do
        schema "$ref": "#/components/schemas/circles_within_response"

        let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
        let!(:circle_outside) { create(:circle, frame: frame, center_x: 8.0, center_y: 8.0, radius: 1.0) }

        let(:center_x) { 25.0 }
        let(:center_y) { 25.0 }
        let(:radius) { 2.0 }
        let(:frame_id) { frame.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(200)
          expect(data).to be_an(Array)
          expect(data).to be_empty
        end
      end

      response(200, 'successful - empty result when missing parameters') do
        let(:center_x) { nil }
        let(:center_y) { nil }
        let(:radius) { nil }
        let(:frame_id) { nil }

        run_test! do |response|
          expect(response.status).to eq(200)
          data = JSON.parse(response.body)
          expect(data).to eq([])
        end
      end
    end
  end

  path '/circles/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Circle ID'

    put('update circle') do
      tags 'Circles'
      description 'Updates a specific circle by ID'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :circle, in: :body, schema: {
        "$ref": "#/components/schemas/circle_update_request"
      }

      response(200, 'successful update') do
        schema "$ref": "#/components/schemas/circle_response"

        let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
        let(:existing_circle) { create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0) }
        let(:id) { existing_circle.id }
        let(:circle) do
          {
            circle: {
              center_x: 12.0,
              center_y: 12.0,
              radius: 3.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(200)
          expect(data['id']).to eq(existing_circle.id)
          expect(data['center_x']).to eq('12.0')
          expect(data['center_y']).to eq('12.0')
          expect(data['radius']).to eq('3.0')
          expect(data['frame_id']).to eq(frame.id)
        end
      end

      response(422, 'unprocessable entity - validation errors') do
        schema "$ref": "#/components/schemas/circle_update_error_response"

        context 'with invalid parameters - circle outside frame bounds' do
          let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 10.0, height: 10.0) }
          let(:existing_circle) { create(:circle, frame: frame, center_x: 13.0, center_y: 13.0, radius: 1.0) }
          let(:id) { existing_circle.id }
          let(:circle) do
            {
              circle: {
                center_x: 5.0,
                center_y: 5.0,
                radius: 2.0
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(data['base']).to include('Circle must be completely within the frame')
          end
        end

        context 'with invalid parameters - circle collision' do
          let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
          let!(:other_circle) { create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0) }
          let(:existing_circle) { create(:circle, frame: frame, center_x: 20.0, center_y: 20.0, radius: 1.0) }
          let(:id) { existing_circle.id }
          let(:circle) do
            {
              circle: {
                center_x: 11.0,  # Too close to other_circle
                center_y: 10.0,
                radius: 2.0
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(data['base']).to include(/Circle collides with existing circle/)
          end
        end

        context 'with invalid parameters - negative values' do
          let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
          let(:existing_circle) { create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0) }
          let(:id) { existing_circle.id }
          let(:circle) do
            {
              circle: {
                center_x: -5.0,
                center_y: -10.0,
                radius: -2.0
              }
            }
          end

          run_test! do |response|
            data = JSON.parse(response.body)
            expect(response.status).to eq(422)
            expect(data['center_x']).to include('must be greater than or equal to 0')
            expect(data['center_y']).to include('must be greater than or equal to 0')
            expect(data['radius']).to include('must be greater than 0')
          end
        end
      end

      response(404, 'not found') do
        schema "$ref": "#/components/schemas/not_found_response"

        let(:id) { 999999 }
        let(:circle) do
          {
            circle: {
              center_x: 12.0,
              center_y: 12.0,
              radius: 3.0
            }
          }
        end

        run_test! do |response|
          expect(response.status).to eq(404)
        end
      end
    end

    patch('update circle') do
      tags 'Circles'
      description 'Updates a specific circle by ID'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :circle, in: :body, schema: {
        "$ref": "#/components/schemas/circle_update_request"
      }

      response(200, 'successful update') do
        schema "$ref": "#/components/schemas/circle_response"

        let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
        let(:existing_circle) { create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0) }
        let(:id) { existing_circle.id }
        let(:circle) do
          {
            circle: {
              center_x: 12.0,
              center_y: 12.0,
              radius: 3.0
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(response.status).to eq(200)
          expect(data['id']).to eq(existing_circle.id)
          expect(data['center_x']).to eq('12.0')
          expect(data['center_y']).to eq('12.0')
          expect(data['radius']).to eq('3.0')
        end
      end
    end

    delete('destroy circle') do
      tags 'Circles'
      description 'Deletes a specific circle by ID'
      produces 'application/json'
      consumes 'application/json'

      response(204, 'successful deletion') do
        let(:frame) { create(:frame, center_x: 15.0, center_y: 15.0, width: 30.0, height: 30.0) }
        let(:existing_circle) { create(:circle, frame: frame, center_x: 10.0, center_y: 10.0, radius: 2.0) }
        let(:id) { existing_circle.id }

        run_test! do |response|
          expect(response.status).to eq(204)
          expect(response.body).to be_empty
          expect(Circle.exists?(existing_circle.id)).to be_falsey
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
end
