# frozen_string_literal: true

require 'rails_helper'

module EasyMonitor
  module Influxdb
    RSpec.describe Client do
      let(:influxdb_client) { described_class.new(time_precision: 'ms') }
      context 'when connecting' do
        it 'returns a client' do
          expect(influxdb_client.is_a?(EasyMonitor::Influxdb::Client)).to eq(true)
        end

        it 'has an instance variable of type InfluxDB::Client' do
          expect(
            influxdb_client.client.is_a?(
              InfluxDB::Client
            )
          ).to eq(true)
        end
      end

      context 'when writing' do
        describe '#write' do
          let(:database) { 'easy_monitor' }
          let(:tags) { { type: 'test' } }
          let(:values) { { value: 'my value' } }
          let(:body) do
            InfluxDB::PointValue.new(
              influxdb_client.data(tags, values).merge(series: 'test')
            ).dump
          end

          before do
            stub_request(:post, 'http://localhost:8086/write').with(
              query: { u: 'root', p: 'root', precision: 'ms', db: database },
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                'Content-Type' => 'application/octet-stream',
                'User-Agent' => 'Ruby'
              },
              body: body
            ).to_return(status: 204)
          end

          it 'returns a 204 after writing' do
            expect(influxdb_client.write(
                     'test',
                     values,
                     tags
                   )).to be_a(Net::HTTPSuccess)
          end
        end
      end
    end
  end
end
