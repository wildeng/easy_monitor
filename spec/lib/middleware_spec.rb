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

  context 'when called with a GET request' do
    before do
      allow_any_instance_of(described_class).to receive(
        :influxdb_write_actions
      ).and_return(true)

      allow_any_instance_of(described_class).to receive(
        :influxdb_write_exceptions
      ).and_return(true)
      request.get('/users/1', 'CONTENT_TYPE' => 'text/plain')
    end

    it 'passes the request through unchanged' do
      expect(app['CONTENT_TYPE']).to eq('text/plain')
      expect(subject.influxdb_write_actions(request, Time.now)).to eq(true)
    end

    it 'catches the exceptions and passes it over' do
      expect do
        request.get('users/error', 'CONTENT_TYPE' => 'text/plain')
      end.to raise_error StandardError
      expect(
        subject.influxdb_write_exceptions(app.env, 'exception')
      ).to eq(true)
    end
  end


  context 'when called with a POST request' do
    before do
      allow_any_instance_of(described_class).to receive(
        :influxdb_write_actions
      ).and_return(true)

      allow_any_instance_of(described_class).to receive(
        :influxdb_write_exceptions
      ).and_return(true)
      request.post('/users?name=Foo&surname=Bar', 'CONTENT_TYPE' => 'text/plain')
    end

    it 'passes the request through unchanged' do
      expect(app['CONTENT_TYPE']).to eq('text/plain')
      expect(app.env['QUERY_STRING']).to eq('name=Foo&surname=Bar')
      expect(subject.influxdb_write_actions(request, Time.now)).to eq(true)
    end

    it 'catches the exceptions and passes it over' do
      expect do
        request.post('users/error?user=baz', 'CONTENT_TYPE' => 'text/plain')
      end.to raise_error StandardError
      expect(
        subject.influxdb_write_exceptions(app.env, 'exception')
      ).to eq(true)
    end
  end
end
