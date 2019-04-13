require 'rails_helper'
require 'mock_redis'

module EasyMonitor
  RSpec.describe HealthChecksController, type: :controller do
    routes { EasyMonitor::Engine.routes }
    describe 'GET alive' do
      it 'responds with 204 when hit' do
        get :alive
        expect(response.code).to eq('204')
      end
    end

    context 'when checking a Redis server' do
      describe 'GET redis_alive' do
        it 'responds with 204 when hit' do
          redis = MockRedis.new
          allow(Redis).to receive(:new).and_return(redis)
          get :redis_alive
          expect(response.code).to eq('204')
        end

        it 'respond with request_timeout when not working' do
          get :redis_alive
          expect(response.code).to eq('408')
        end
      end
    end
  end
end
