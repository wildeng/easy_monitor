# frozen_string_literal: true

require 'rails_helper'
require 'mock_redis'
require 'rotp'

module EasyMonitor
  RSpec.describe HealthChecksController, type: :controller do
    routes { EasyMonitor::Engine.routes }
    describe 'GET alive' do
      it 'responds with 200 and a message when hit' do
        get :alive
        expect(response.code).to eq('200')
        body = JSON.parse(response.body)
        expect(body['message']).to eq('System is alive')
      end

      it 'responds with 200 when json' do
        get :alive, format: 'json'
        message = JSON.parse(response.body)
        expect(response.code).to eq('200')
        expect(message['message']).to eq('System is alive')
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
        it 'responds with 200 and a message when not set or not working' do
          get :sidekiq_alive
          expect(EasyMonitor::Engine.use_sidekiq).to eq(false)
          body = JSON.parse(response.body)
          expect(response.code).to eq('200')
          expect(body['message']).to eq('Sidekiq is not responding or not set')
        end

        it 'responds with 200 and a message when high latency' do
          high_latency
          get :sidekiq_alive
          body = JSON.parse(response.body)
          expect(response.code).to eq('200')
          expect(body['message']).to eq('Sidekiq is experiencing a high latency')
        end

        it 'responds with 200 and a message when high queue' do
          high_queue
          get :sidekiq_alive
          body = JSON.parse(response.body)
          expect(response.code).to eq('200')
          expect(body['message']).to eq('Too many jobs enqueued in Sidekiq')
        end

        it 'responds with 200 and a message when alive' do
          alive
          get :sidekiq_alive
          body = JSON.parse(response.body)
          expect(response.code).to eq('200')
          expect(body['message']).to eq('Sidekiq is alive')
        end
      end
    end
  end
end
