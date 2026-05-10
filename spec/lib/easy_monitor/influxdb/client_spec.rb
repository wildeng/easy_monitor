# frozen_string_literal: true

require 'rails_helper'

module EasyMonitor
  module Influxdb
    RSpec.describe Client do
      let(:influxdb_double) { instance_double(InfluxDB::Client, write_point: nil) }
      let(:influxdb_client) { described_class.new(time_precision: 'ms') }

      before do
        allow(InfluxDB::Client).to receive(:new).and_return(influxdb_double)
      end

      context 'when connecting' do
        it 'returns a client' do
          expect(influxdb_client.is_a?(EasyMonitor::Influxdb::Client)).to eq(true)
        end

        it 'initializes InfluxDB::Client with correct params' do
          influxdb_client
          expect(InfluxDB::Client).to have_received(:new).with(
            'easy_monitor', hash_including(host: 'localhost', port: '8086', time_precision: 'ms')
          )
        end
      end

      context 'when writing' do
        describe '#write' do
          let(:tags) { { type: 'test' } }
          let(:values) { { value: 'my value' } }

          before do
            allow(influxdb_double).to receive(:write_point).and_return(
              instance_double(Net::HTTPSuccess, code: '204')
            )
          end

          it 'delegates to InfluxDB::Client#write_point' do
            influxdb_client.write('test', values, tags)
            expect(influxdb_double).to have_received(:write_point).with(
              'test', { tags: tags, values: values }
            )
          end
        end
      end
    end
  end
end
