require 'rails_helper'

module EasyMonitor
  RSpec.describe HealthChecksController, type: :controller do
    routes { EasyMonitor::Engine.routes }
    describe 'GET alive' do
      it 'responds with 204 when hit' do
        get :alive
        expect(response.code).to eq('204')
      end
    end
  end
end
