require 'rails_helper'

RSpec.describe EasyMonitor do
  context 'when default config' do
    describe '#configure' do
      it 'responds with redis default' do
        expect(EasyMonitor::Engine.redis_url).to eq('127.0.0.1')
        expect(EasyMonitor::Engine.redis_port).to eq(6379)
      end

      it 'responds with default user class value' do
        expect(EasyMonitor::Engine.user_class).to eq(nil)
      end
    end
  end

  context 'when user config' do
    describe '#configure' do
      before do
        EasyMonitor::Engine.setup do |config|
          config.redis_url = '10.10.2.3'
          config.redis_port = 8080
          config.user_class = 'User'
        end
      end
      it 'responds with redis config' do
        expect(EasyMonitor::Engine.redis_url).to eq('10.10.2.3')
        expect(EasyMonitor::Engine.redis_port).to eq(8080)
      end

      it 'responds with user defined class' do
        expect(EasyMonitor::Engine.user_class).to eq('User')
      end
    end
  end
end
