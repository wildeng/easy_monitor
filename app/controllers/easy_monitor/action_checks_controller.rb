# frozen_string_literal: true

module EasyMonitor
  class ActionChecksController < ApplicationController
    attr_accessor :test_var
    def all_controller_actions
      @test_var
    end
  end
end
