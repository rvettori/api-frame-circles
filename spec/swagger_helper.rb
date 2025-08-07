# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: ENV.fetch('SWAGGER_HOST', 'localhost:3000')
            }
          }
        }
      ],
      components: {
        schemas: {
          frame_response: {
            type: :object,
               properties: {
                 id: { type: :integer, example: 1 },
                 center_x: { type: :decimal, format: 'double', example: 10.0 },
                 center_y: { type: :decimal, format: 'double', example: 15.0 },
                 circles_count: { type: :integer, example: 3 },
                 circle_top_position: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     center_x: { type: :decimal, format: 'double', example: 10.0 },
                     center_y: { type: :decimal, format: 'double', example: 15.0 }
                   }
                 },
                 circle_down_position: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     center_x: { type: :decimal, format: 'double', example: 10.0 },
                     center_y: { type: :decimal, format: 'double', example: 15.0 }
                   }
                 },
                 circle_left_position: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     center_x: { type: :decimal, format: 'double', example: 10.0 },
                     center_y: { type: :decimal, format: 'double', example: 15.0 }
                   }
                 },
                 circle_right_position: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     center_x: { type: :decimal, format: 'double', example: 10.0 },
                     center_y: { type: :decimal, format: 'double', example: 15.0 }
                   }
                 }
               },
               required: %w[id center_x center_y circles_count]
          },
          frame_create_response: {
            type: :object,
            properties: {
              id: { type: :integer },
              center_x: { type: :decimal, format: 'double', example: 15.0 },
              center_y: { type: :decimal, format: 'double', example: 15.0 },
              height: { type: :decimal, format: 'double', example: 20.0 },
              width: { type: :decimal, format: 'double', example: 20.0 },
              circles_count: { type: :integer },
                 circle_top_position: {
                   anyOf: [
                     { type: :null },
                     {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         center_x: { type: :decimal, format: 'double', example: 10.0 },
                         center_y: { type: :decimal, format: 'double', example: 15.0 }
                       }
                     }
                   ]
                 },
                 circle_down_position: {
                   anyOf: [
                     { type: :null },
                     {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         center_x: { type: :decimal, format: 'double', example: 10.0 },
                         center_y: { type: :decimal, format: 'double', example: 15.0 }
                       }
                     }
                   ]
                 },
                 circle_left_position: {
                   anyOf: [
                     { type: :null },
                     {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         center_x: { type: :decimal, format: 'double', example: 10.0 },
                         center_y: { type: :decimal, format: 'double', example: 15.0 }
                       }
                     }
                   ]
                 },
                 circle_right_position: {
                   anyOf: [
                     { type: :null },
                     {
                       type: :object,
                       properties: {
                         id: { type: :integer, example: 1 },
                         center_x: { type: :decimal, format: 'double', example: 10.0 },
                         center_y: { type: :decimal, format: 'double', example: 15.0 }
                       }
                     }
                   ]
                 }
            },
            required: %w[id center_x center_y height width circles_count]
          },
          frame_create_request: {
            type: :object,
            properties: {
              frame: {
                type: :object,
                properties: {
                  center_x: { type: :number, format: :decimal, example: 15.0 },
                  center_y: { type: :number, format: :decimal, example: 15.0 },
                  height: { type: :number, format: :decimal, example: 20.0 },
                  width: { type: :number, format: :decimal, example: 20.0 },
                  circles_attributes: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        center_x: { type: :number, format: :decimal, example: 10.0 },
                        center_y: { type: :number, format: :decimal, example: 10.0 },
                        radius: { type: :number, format: :decimal, example: 2.0 }
                      },
                      required: %w[center_x center_y radius]
                    }
                  }
                },
                required: %w[center_x center_y height width]
              }
            },
            required: %w[frame]
          },
          frame_create_error_response: {
            type: :object,
            properties: {
              base: {
                type: :array,
                items: { type: :string }
              },
              center_x: {
                type: :array,
                items: { type: :string }
              },
              center_y: {
                type: :array,
                items: { type: :string }
              },
              height: {
                type: :array,
                items: { type: :string }
              },
              width: {
                type: :array,
                items: { type: :string }
              }
            }
          },
          not_found_response: {
            type: :object,
            properties: {
              error: { type: :string, example: 'Record not found' }
            }
          },
          frame_destroy_error_response: {
            type: :object,
            properties: {
              base: {
                type: :array,
                items: { type: :string },
                example: [ 'Cannot delete record because dependent circles exist' ]
              }
            },
            required: %w[base]
          },
          circle_response: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              center_x: { type: :string, example: '10.0' },
              center_y: { type: :string, example: '10.0' },
              radius: { type: :string, example: '2.0' },
              frame_id: { type: :integer, example: 1 }
            },
            required: %w[id center_x center_y radius frame_id]
          },
          circles_within_response: {
            type: :array,
            items: {
              "$ref": "#/components/schemas/circle_response"
            }
          },
          circle_update_request: {
            type: :object,
            properties: {
              circle: {
                type: :object,
                properties: {
                  center_x: { type: :number, format: :decimal, example: 12.0 },
                  center_y: { type: :number, format: :decimal, example: 12.0 },
                  radius: { type: :number, format: :decimal, example: 3.0 }
                }
              }
            },
            required: %w[circle]
          },
          circle_update_error_response: {
            type: :object,
            properties: {
              base: {
                type: :array,
                items: { type: :string }
              },
              center_x: {
                type: :array,
                items: { type: :string }
              },
              center_y: {
                type: :array,
                items: { type: :string }
              },
              radius: {
                type: :array,
                items: { type: :string }
              }
            }
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
