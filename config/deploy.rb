
set :application, 'guclink_organizer'
set :repo_url, 'git@github.com:ah450/guclink-organizer-service.git'
set :branch, 'master'
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/organizeruser/guclink-organizer-service'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :local_user, 'organizeruser'
set :rbenv_ruby, '2.2.4'
set :rbenv_type, :user
set :sidekiq_config, "#{current_path}/config/sidekiq.yml"
set :sidekiq_log, "#{current_path}/log/sidekiq.log"
set :sidekiq_pid, "#{current_path}/sidekiq.pid"
set :thin_config_path, "#{current_path}/config/thin.yml"
set :sidekiq_processes, 3
namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after 'deploy:publishing', 'thin:restart'

end
