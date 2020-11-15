# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "todo"
set :repo_url, "git@github.com:vladimir-belich/todo.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

# Sidekiq
#set :sidekiq_role, :app
#set :sidekiq_env, 'production'

# Default value for linked_dirs is []
 append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for keep_releases is 5
 set :keep_releases, 5
