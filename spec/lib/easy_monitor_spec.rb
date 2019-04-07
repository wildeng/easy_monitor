require 'rails_helper'

RSpec.describe EasyMonitor do

  describe '#configure' do
    it 'responds with nil as default redis url' do
      expect(EasyMonitor.redis_url).to eq(nil)
    end
  end
end
