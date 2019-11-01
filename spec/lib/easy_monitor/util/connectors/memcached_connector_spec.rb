require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe MemcachedConnector do
        context 'when using memcached' do
          describe '#memcached_alive?' do
            let(:memcached_conn) { described_class.new(Rails.cache) }
            
            it 'returns true if running' do
              allow(Rails.cache).to receive(:write).and_return(true)
              allow(Rails.cache).to receive(:read).with('ping').and_return('pong')
              expect(memcached_conn.memcached_alive?).to eq(true)
            end

            it 'returns false if not reading' do
              allow(Rails.cache).to receive(:write).and_return(true)
              allow(Rails.cache).to receive(:read).and_return(nil)
              expect(memcached_conn.memcached_alive?).to eq(false)
            end

            it 'returns false if not writing' do
              allow(Rails.cache).to receive(:write).and_return(false)
              expect(memcached_conn.memcached_alive?).to eq(false)
            end
          end
        end
      end
    end
  end
end
 
   
