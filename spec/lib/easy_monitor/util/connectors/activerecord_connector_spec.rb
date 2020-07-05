# frozen_string_literal: true
require 'rails_helper'

module EasyMonitor
  module Util
    module Connectors
      RSpec.describe ActiverecordConnector do
        def use_active_record(use = false)
          EasyMonitor::Engine.setup do |config|
            config.use_active_record = use
          end
        end

        context 'When not using a database' do
          describe " check not set up" do
            it "raises an error if not set up" do
              expect { database_conn.database_alive? }.to raise_error(
                StandardError
              )
            end
          end
        end

        context "When using a database" do
          let(:conn) { MockDbConnection.new }
          let(:database_conn) { ActiverecordConnector.new(conn) }

          describe "#database_alive?" do
            before(:each) do
              use_active_record(true)
            end

            it "returns true if alive" do
              expect(database_conn.database_alive?).to eq(true)
            end

            it "return false if not working" do
              allow_any_instance_of(
                MockConnector
              ).to receive(:active?).and_return(false)
              expect(database_conn.database_alive?).to eq(false)
            end
          end
        end
      end
    end
  end
end
