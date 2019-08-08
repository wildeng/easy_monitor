require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe SidekiqConnector do
        def use_sidekiq(use = false)
          EasyMonitor::Engine.setup do |config|
            config.use_sidekiq = use
          end
        end

        def high_latency(high = false)
          allow_any_instance_of(described_class).to receive(
            :high_latency?
          ).and_return(high)
        end

        def high_queue_number(high = false)
          allow_any_instance_of(described_class).to receive(
            :high_queue_number?
          ).and_return(high)
        end

        def processing(high = false)
          allow_any_instance_of(described_class).to receive(
            :processing?
          ).and_return(high)
        end

        context 'when initialising' do
          describe 'creating instances' do
            it 'returns only one instance' do
              one = described_class.instance
              two = described_class.instance

              expect(one).to eq(two)
            end

            it 'returns a latency' do
              allow_any_instance_of(Sidekiq::Queue).to receive(:latency).and_return(200)
              expect(described_class.instance.latency).to eq(200)
            end

            it 'return sidekiq stats' do
              stats = double(enqueued: 10, processes_size: 2)
              allow_any_instance_of(Sidekiq::Stats).to receive(:fetch_stats!).and_return(stats)
              expect(described_class.instance.stats.class).to eq(Sidekiq::Stats)
            end

            it 'returns false if latency is low' do
              allow_any_instance_of(Sidekiq::Queue).to receive(:latency).and_return(200)
              expect(described_class.instance.high_latency?).to eq(false)
            end

            it 'returns true if latency is high' do
              allow_any_instance_of(Sidekiq::Queue).to receive(:latency).and_return(700)
              expect(described_class.instance.high_latency?).to eq(true)
            end
          end

          describe 'checking sidekiq stats' do
            before(:each) do
              stats = double(enqueued: 10, processes_size: 2)
              allow_any_instance_of(described_class).to receive(:stats).and_return(stats)
            end

            it 'returns true if processes are in place' do
              expect(described_class.instance.processing?).to eq(true)
            end

            it 'returns false if the enqueued jobs are a few' do
              expect(described_class.instance.high_queue_number?).to eq(false)
            end
          end
        end

        context 'when there are problems' do
          before do
            use_sidekiq(true)
          end

          describe 'high latency' do
            it 'raises a HighLatencyError' do
              high_latency(true)
              expect { described_class.instance.alive? }.to raise_error(
                EasyMonitor::Util::Errors::HighLatencyError
              )
            end
          end

          describe 'too many enqueued jobs' do
            it 'raises a HighQueueNumberError' do
              high_latency
              high_queue_number(true)
              expect { described_class.instance.alive? }.to raise_error(
                EasyMonitor::Util::Errors::HighQueueNumberError
              )
            end
          end

          describe 'no processes' do
            it 'raises a StandardError' do
              high_latency
              high_queue_number
              processing
              expect { described_class.instance.alive? }.to raise_error(
                StandardError
              )
            end
          end
        end

        context 'when everything is alive' do
          before do
            use_sidekiq(true)
          end

          it 'returns true if everything is working' do
            high_latency
            high_queue_number
            processing(true)
            expect(described_class.instance.alive?).to eq(true)
          end
        end
      end
    end
  end
end
