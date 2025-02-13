Rails.application.config.session_store :redis_store, servers: ENV['REDIS_URL'] || 'redis://localhost:6379/0/session',
                                                     expire_in: 90.minutes
