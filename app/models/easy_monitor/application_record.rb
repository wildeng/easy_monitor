# frozen_string_literal: true

# basic active record class

module EasyMonitor
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
