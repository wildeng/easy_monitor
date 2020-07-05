# frozen_string_literal: true

class MockDbConnection
  def connection
    MockConnector.new
  end
end
