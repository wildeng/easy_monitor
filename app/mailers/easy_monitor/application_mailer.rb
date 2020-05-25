# frozen_string_literal: true

# basic mailer class

module EasyMonitor
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
