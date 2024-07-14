# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Activity board', type: :request do
  describe 'GET /activity_board' do
    include_context 'with authenticated user'

    let(:url) { '/activity_board' }
    let(:request) { get url, headers: headers(response) }

    context 'with existing activities' do
      before do
        create_list(:activity, 5)
      end

      it 'returns all public activities' do
        request

        expect(json_response.count).to eq(5)
      end
    end

    context 'with existing private activities' do
      before do
        create_list(:activity, 5, public: false)
      end

      it 'returns no activities' do
        request

        expect(json_response.count).to eq(0)
      end
    end

    context 'with no existing activities' do
      it 'returns no activities' do
        request

        expect(json_response.count).to eq(0)
      end
    end

    context 'when not authenticated' do
      it 'validates authentication' do
        get url

        expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'GET /activity_board/:id' do
    include_context 'with authenticated user'

    let(:url) { "/activity_board/#{id}" }
    let(:request) { get url, headers: headers(response) }

    context 'with existing activities' do
      let(:activity1) { create(:activity) }
      let(:id) { activity1.id }

      it 'returns the queried activity' do
        request

        expect(json_response).to eq(activity1.as_json)
      end
    end

    context 'when the activity does not exist' do
      let(:id) { 0 }

      it 'returns no activities' do
        request

        expect(response.status).to eq(404)
        expect(json_response['title']).to eq('Resource not found')
      end
    end

    context 'when not authenticated' do
      let(:activity1) { create(:activity) }
      let(:id) { activity1.id }

      it 'validates authentication' do
        get "/activity_board/#{id}"

        expect(json_response['title']).to eq('You need to sign in or sign up before continuing.')
        expect(response.status).to eq(401)
      end
    end
  end
end
