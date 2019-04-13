require 'rails_helper'

RSpec.describe EasyMonitor do

  describe '#configure' do
    it 'responds with redis config' do
      expect(EasyMonitor::Engine.redis_url).to eq('127.0.0.1')
      expect(EasyMonitor::Engine.redis_port).to eq(6379)
    end
  end
end
