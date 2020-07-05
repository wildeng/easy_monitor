# frozen_string_literal: true

EasyMonitor::Engine.routes.draw do
  get 'action_checks/all_actions', to: 'action_checks#all_controller_actions'
  get 'caching_checks/memcached_alive', to: 'caching_checks#memcached_alive'
  get 'caching_checks/redis_alive', to: 'caching_checks#redis_alive'
  get 'health_checks/alive', to: 'health_checks#alive'
  get 'health_checks/sidekiq_alive', to: 'health_checks#sidekiq_alive'
  get 'health_checks/active_record_alive', to: 'health_checks#active_record_alive'
end
