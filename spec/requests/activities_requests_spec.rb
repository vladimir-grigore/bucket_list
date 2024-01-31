# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Activities', type: :request do
  describe 'POST /activities' do
    include_context 'with authenticated user'

    let(:url) { '/activities' }
    let(:user) { Users::CreateService.new.call(build(:user)) }
    let(:params) do
      {
        name: 'Climb Everest',
        description: 'I want to see the top of the world',
        public: true,
        deadline: '12/09/2067'
      }
    end

    let(:request) { post url, params: params.to_json, headers: headers(response) }

    it 'creates the activity' do
      request

      expect(json_response['name']).to eq('Climb Everest')
      expect(json_response['description']).to eq('I want to see the top of the world')
      expect(json_response['public']).to be_truthy
      expect(response.status).to eq(201)
    end

    it 'assigns it to the user' do
      request

      expect(user.activities.count).to eq(1)
      expect(json_response['user_id']).to eq(user.id)
    end

    context 'with invalid arguments' do
      let(:params) do
        {
          foo: 'Climb Everest',
          bar: 'I want to see the top of the world',
          public: true,
          deadline: '12/09/2067'
        }
      end

      it 'validates request params' do
        request

        expect(json_response['title']).to eq("Validation failed: Name can't be blank, Description can't be blank")
        expect(response.status).to eq(422)
      end
    end

    context 'with missing arguments' do
      let(:params) do
        {
          description: 'I want to see the top of the world',
          public: true,
          deadline: '12/09/2067'
        }
      end

      it 'validates missing params' do
        request

        expect(json_response['title']).to eq("Validation failed: Name can't be blank")
        expect(response.status).to eq(422)
      end
    end
  end
end
