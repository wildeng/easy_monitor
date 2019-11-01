EasyMonitor::Engine.routes.draw do
  get 'health_checks/alive', to: 'health_checks#alive'
  get 'health_checks/memcached_alive', to: 'health_checks#memcached_alive'
  get 'health_checks/redis_alive', to: 'health_checks#redis_alive'
  get 'health_checks/sidekiq_alive', to: 'health_checks#sidekiq_alive'
end
