require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe RedisConnector do
        context 'when initialising' do
          describe 'creating instances' do
            it 'returns only one instance' do
              one = described_class.instance
              two = described_class.instance

              expect(one).to eq(two)
            end
          end

          describe 'all defaults are set' do
            let(:mock_redis) do
              redis = MockRedis.new
              allow(
                EasyMonitor::Util::Connectors::RedisConnector.instance
              ).to receive(:connection).and_return(redis)
            end

            it 'returns an error when redis is not available' do
              expect { described_class.instance.connection.url }.to raise_error(
                Redis::CannotConnectError
              )
              expect { described_class.instance.connection.host }.to raise_error(
                Redis::CannotConnectError
              )
            end

            it 'returns default url and port' do
              mock_redis
              expect(described_class.instance.connection.host).to eq(
                EasyMonitor::Engine.redis_url
              )
              expect(described_class.instance.connection.port).to eq(
                EasyMonitor::Engine.redis_port
              )
            end

            it 'returns the ping result' do
              redis = MockRedis.new
              allow(
                EasyMonitor::Util::Connectors::RedisConnector
              ).to receive(:instance).and_return(redis)
              expect(described_class.instance.ping).to eq('PONG')
            end
          end
        end
      end
    end
  end
end
