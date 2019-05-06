require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe SidekiqConnector do
        context 'when initialising' do
          describe 'creating instances' do
            it 'returns only one instance' do
              one = described_class.instance
              two = described_class.instance

              expect(one).to eq(two)
            end
          end
        end

        context 'when there are problems' do
          before do
            EasyMonitor::Engine.setup do |config|
              config.use_sidekiq = true
            end
          end

          def high_latency(high=false)
            allow_any_instance_of(described_class).to receive(
              :high_latency?
            ).and_return(high)
          end

          def high_queue_number(high=false)
            allow_any_instance_of(described_class).to receive(
              :high_queue_number?
            ).and_return(high)
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
            # TODO: this test is failing needs to be fixed
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
              allow_any_instance_of(described_class).to receive(
                :processing?
              ).and_return(false)
              expect { described_class.instance.alive? }.to raise_error(
                StandardError
              )
            end
          end
        end
      end
    end
  end
end
