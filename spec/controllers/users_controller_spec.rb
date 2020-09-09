# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:token) { Doorkeeper::AccessToken.create!(resource_owner_id: user.id, previous_refresh_token: 'abcd') }
  let!(:phone_number) { create(:phone_number, user_id: user.id, phone_number: '1231231240') }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
    allow_any_instance_of(Api::V1::UsersController).to receive(:current_user).and_return user
  end

  describe 'GET Users#me' do
    context 'get profile' do
      it 'returns user profile with code 200' do
        request.content_type = 'application/json'
        get :me
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response[:message]).to eq 'success'
        expect(json_response[:data][:user][:email]).to eq user.email
      end
    end
  end

  describe 'POST Users#allocate_phone_number' do
    context 'post allocate_phone_number preferred' do
      it 'returns user profile with code 200' do
        request.content_type = 'application/json'
        post :allocate_phone_number, params: { phone_number: '1231231239' }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response[:phone_number]).to eql '1231231239'
      end
    end

    context 'post allocate_phone_number preferred' do
      it 'returns user profile with code 200' do
        request.content_type = 'application/json'
        post :allocate_phone_number, params: { phone_number: '1231231240' }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response[:phone_number]).not_to eql '1231231240'
      end
    end

    context 'post allocate_phone_number' do
      it 'returns user profile with code 200' do
        request.content_type = 'application/json'
        post :allocate_phone_number, params: { phone_number: nil }
        json_response = JSON.parse(response.body).with_indifferent_access
        expect(response).to have_http_status(200)
        expect(json_response).to have_key(:phone_number)
      end
    end
  end
end