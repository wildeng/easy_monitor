#frozen_string_literal: true

module EasyMonitor
  module Util
    module Connectors
      class ActiverecordConnector
        attr_accessor :base

        def initialize(base = ActiveRecord::Base)
          self.base = base
        end

        def database_alive?
          raise StandardError unless EasyMonitor::Engine.use_active_record
          base.connection.active?
        end
      end
    end
  end
end
