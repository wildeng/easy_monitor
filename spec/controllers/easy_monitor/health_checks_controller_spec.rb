require 'rails_helper'
require 'mock_redis'
require 'rotp'

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
          redis = MockRedis.new
          allow(redis).to receive(:ping).and_raise(Redis::CannotConnectError)
          allow(
            EasyMonitor::Util::Connectors::RedisConnector
          ).to receive(:instance).and_return(redis)
          get :redis_alive
          expect(response.code).to eq('408')
        end

        it 'respond with request_timeout when catching an error' do
          allow(
            EasyMonitor::Util::Connectors::RedisConnector
          ).to receive(:instance).and_return(nil)
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
      context 'when checking Redis with totp auth' do
        describe 'GET redis_alive' do

          before(:all) do
            EasyMonitor::Engine.use_totp = true
            EasyMonitor::Engine.totp_secret = 'WVE5ICKVODGWLZZN2WTKBQ2TGG5SUMDC'
          end

          after(:all) do
            EasyMonitor::Engine.use_totp = false
          end

          it 'responds with 204 when hit' do
            redis = MockRedis.new
            allow(
              EasyMonitor::Util::Connectors::RedisConnector
            ).to receive(:instance).and_return(redis)
            totp_code = ROTP::TOTP.new(EasyMonitor::Engine.totp_secret).now
            params = { totp_code: totp_code }
            get :redis_alive, params: params
            expect(response.code).to eq('204')
          end

          it 'responds with unauthorized when hit without params' do
            redis = MockRedis.new
            allow(
              EasyMonitor::Util::Connectors::RedisConnector
            ).to receive(:instance).and_return(redis)
            totp_code = ROTP::TOTP.new(EasyMonitor::Engine.totp_secret).now
            get :redis_alive
            expect(response.code).to eq('401')
          end
        end
      end
    end

    context 'when checking memcached' do
      def memcached_alive(value)
        allow_any_instance_of(
          EasyMonitor::Util::Connectors::MemcachedConnector
        ).to receive(:memcached_alive?).and_return(value)
      end

      describe 'GET memcached alive' do
        it 'responds with 501 when not used' do
          get :memcached_alive
          expect(EasyMonitor::Engine.use_memcached).to eq(false)
          expect(response.code).to eq('501')
        end

        it 'responds with 503 when not working' do
          EasyMonitor::Engine.use_memcached = true
          memcached_alive(false)
          get :memcached_alive
          expect(response.code).to eq('503')
        end
      end
    end
 
    context 'when checking Sidekiq' do
      let(:alive) do
        allow_any_instance_of(
          EasyMonitor::Util::Connectors::SidekiqConnector
        ).to receive(:alive?).and_return(true)
      end

      let(:high_latency) do
        allow_any_instance_of(
          EasyMonitor::Util::Connectors::SidekiqConnector
        ).to receive(:alive?).and_raise(
          EasyMonitor::Util::Errors::HighLatencyError
        )
      end

      let(:high_queue) do
        allow_any_instance_of(
          EasyMonitor::Util::Connectors::SidekiqConnector
        ).to receive(:alive?).and_raise(
          EasyMonitor::Util::Errors::HighQueueNumberError
        )
      end

      describe 'GET Sidekiq alive' do
        it 'responds with request_timeout when not set or not working' do
          get :sidekiq_alive
          expect(EasyMonitor::Engine.use_sidekiq).to eq(false)
          expect(response.code).to eq('408')
        end

        it 'responds with request_timeout when high latency' do
          high_latency
          get :sidekiq_alive
          expect(response.code).to eq('408')
        end

        it 'responds with request_timeout when high queue' do
          high_queue
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
