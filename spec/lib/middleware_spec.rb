# frozen_string_literal: true

require 'rails_helper'

# testing inspired by this nice stack overflow post
#
# https://stackoverflow.com/questions/17506567/testing-middleware-with-rspec
#
RSpec.describe EasyMonitor::Middleware do
  let(:app) { MockRackApp.new }
  let(:subject) { described_class.new(app) }
  let(:request) { Rack::MockRequest.new(subject) }
  let(:client) do
    EasyMonitor::Influxdb::Client.new(
      time_precision: 'ms'
    )
  end

  context 'when influxdb connection is active' do
    before do
      EasyMonitor::Engine.config do |conf|
        conf.use_influxdb = true
      end

      allow_any_instance_of(EasyMonitor::Influxdb::Client).to receive(
        :influxdb_write_actions
      ).and_return(true)

      allow_any_instance_of(EasyMonitor::Influxdb::Client).to receive(
        :influxdb_write_exceptions
      ).and_return(true)
    end

    describe 'called with a GET request' do
      it 'passes the request through unchanged' do
        request.get('/users/1', 'CONTENT_TYPE' => 'text/plain')
        expect(app['CONTENT_TYPE']).to eq('text/plain')
        expect(client.influxdb_write_actions(request, Time.now)).to eq(true)
      end

      it 'catches the exceptions and passes it over' do
        expect do
          request.get('users/error', 'CONTENT_TYPE' => 'text/plain')
        end.to raise_error StandardError
        expect(
          client.influxdb_write_exceptions(app.env, 'exception')
        ).to eq(true)
      end
    end

    describe 'called with a POST request' do
      it 'passes the request through unchanged' do
        request.post('/users?name=Foo&surname=Bar', 'CONTENT_TYPE' => 'text/plain')
        expect(app['CONTENT_TYPE']).to eq('text/plain')
        expect(app.env['QUERY_STRING']).to eq('name=Foo&surname=Bar')
        expect(client.influxdb_write_actions(request, Time.now)).to eq(true)
      end

      it 'catches the exceptions and passes it over' do
        expect do
          request.post('users/error?user=baz', 'CONTENT_TYPE' => 'text/plain')
        end.to raise_error StandardError
        expect(
          client.influxdb_write_exceptions(app.env, 'exception')
        ).to eq(true)
      end
    end
  end
end
