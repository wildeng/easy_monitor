require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe RedisConnector do
        context 'when initialising' do
          describe 'creating instances' do
            it 'returns only one instance' do
              one = described_class.instance
              two = described_class.instance

              expect(one).to eq(two)
            end
          end
        end
      end
    end
  end
end
