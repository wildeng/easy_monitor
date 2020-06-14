# frozen_string_literal: true

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

      it 'responds with 200 when json' do
        get :alive, format: 'json'
        message = JSON.parse(response.body)
        expect(response.code).to eq('200')
        expect(message['status']).to eq(200)
        expect(message['message']).to eq('alive')
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
