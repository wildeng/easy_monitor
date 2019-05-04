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
        it 'respond with request_timeout when not working' do
          get :redis_alive
          expect(response.code).to eq('408')
        end

        it 'responds with 204 when hit' do
          redis = MockRedis.new
          allow(
            EasyMonitor::Util::Connectors::RedisConnector
          ).to receive(:instance).and_return(redis)
          get :redis_alive
          expect(response.code).to eq('204')
        end
      end
    end

    context 'when checking Sidekiq' do

      let(:alive) do
        allow_any_instance_of(
          EasyMonitor::Util::Connectors::SidekiqConnector
        ).to receive(:alive?).and_return(true)
      end

      describe 'GET Sidekiq alive' do
        it 'responds with request_timeout when not working' do
          get :sidekiq_alive
          expect(response.code).to eq('408')
        end

        it 'responds with 204 when alive' do
          alive
          get :sidekiq_alive
          expect(response.code).to eq('204')
        end
      end
    end
  end
end
