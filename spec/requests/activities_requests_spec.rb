# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Activities', type: :request do
  describe 'POST /activities' do
    include_context 'with authenticated user'

    let(:url) { '/activities' }
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
      expect(json_response['user_id']).to eq(user.id)
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

  describe 'when not authenticated' do
    let(:user) { create(:user) }
    let(:activity) { create(:activity, user: user) }
    let(:url) { '/activities' }
    let(:params) do
      {
        name: 'Climb Everest',
        description: 'I want to see the top of the world',
        public: true,
        deadline: '12/09/2067'
      }
    end
    let(:create_request) { post url, params: params.to_json }
    let(:update_request) { put "/activities/#{activity.id}", params: params.to_json }

    it 'validates authentication on create' do
      create_request

      expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
      expect(response.status).to eq(401)
    end

    it 'validates authentication on delete' do
      delete "/activities/#{activity.id}"

      expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
      expect(response.status).to eq(401)
    end

    it 'validates authentication on list' do
      get url

      expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
      expect(response.status).to eq(401)
    end

    it 'validates authentication on update' do
      update_request

      expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
      expect(response.status).to eq(401)
    end
  end

  describe 'DELETE /activities/:id' do
    include_context 'with authenticated user'

    let(:activity) { create(:activity, user: user) }
    let(:url) { "/activities/#{activity.id}" }
    let(:request) { delete url, headers: headers(response) }

    it 'deletes the user activity' do
      request

      expect(response.status).to eq(204)
    end

    context 'when the activity does not exits' do
      let(:url) { '/activities/123a' }

      it 'returns a 404 error' do
        request

        expect(json_response['title']).to eq('Resource not found')
        expect(response.status).to eq(404)
      end
    end

    context 'when the activity belongs to a different user' do
      let(:user2) { create(:user) }
      let(:activity) { create(:activity, user: user2) }
      let(:url) { "/activities/#{activity.id}" }
      let(:request) { delete url, headers: headers(response) }

      it 'returns a 404 error' do
        request

        expect(json_response['title']).to eq('Resource not found')
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'GET /activities' do
    include_context 'with authenticated user'

    let(:url) { '/activities' }
    let(:request) { get url, headers: headers(response) }

    before do
      create_list(:activity, 5, user: user)
    end

    it 'returns all user activities' do
      request

      expect(json_response.first['user_id']).to eq(user.id)
      expect(json_response.count).to eq(5)
      expect(response.status).to eq(200)
    end
  end

  describe 'PUT /activity/:id' do
    include_context 'with authenticated user'

    let(:params) do
      {
        name: 'Climb Everest',
        description: 'I want to see the top of the world',
        public: true,
        deadline: '12/09/2067'
      }
    end

    let(:activity) { create(:activity, user: user) }
    let(:url) { "/activities/#{activity.id}" }
    let(:request) { put url, params: params.to_json, headers: headers(response) }

    it 'updates the activity' do
      request

      expect(json_response['name']).to eq('Climb Everest')
      expect(json_response['name']).not_to eq(activity['name'])
      expect(json_response['description']).to eq('I want to see the top of the world')
      expect(json_response['public']).to be_truthy
      expect(json_response['user_id']).to eq(user.id)
      expect(response.status).to eq(200)
    end

    context 'when the activity belongs to a different user' do
      let(:user2) { create(:user) }
      let(:activity2) { create(:activity, user: user2) }
      let(:url) { "/activities/#{activity2.id}" }

      it 'returns a 404 error' do
        request

        expect(json_response['title']).to eq('Resource not found')
        expect(response.status).to eq(404)
      end
    end

    context 'when the activity does not exist' do
      let(:url) { '/activities/123a' }

      it 'returns a 404 error' do
        request

        expect(json_response['title']).to eq('Resource not found')
        expect(response.status).to eq(404)
      end
    end

    context 'with invalid params' do
      let(:params) do
        {
          foo: 'bar'
        }
      end

      it 'makes no changes to the activity' do
        request

        expect(json_response).to eq(activity.as_json)
      end
    end

    context 'with partial params' do
      let(:params) do
        {
          description: 'Becasue I want to',
          public: false
        }
      end

      it 'updates the activity' do
        request

        expect(json_response['description']).to eq('Becasue I want to')
        expect(json_response['public']).to be_falsy
        expect(json_response['title']).to eq(activity[:title])
        expect(response.status).to eq(200)
      end
    end
  end
end
