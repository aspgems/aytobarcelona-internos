# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'internos'
set :user, 'aytobarcelonadecidim'
set :repo_url, "https://github.com/aspgems/aytobarcelona-internos.git"

set :deploy_to, -> { "/home/#{fetch(:user)}/app" }
set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/chamber.pem')
set :linked_dirs,  fetch(:linked_dirs,  []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Files that won't be copied from script/deploy/{branch}/ into the root directory
set :exclude_deployment_files, []

set :ssh_options, -> {
  {
      user: fetch(:user),
      forward_agent: true,
      compression: 'none'
  }
}

set :rails_env, 'production'
set :scm, :git
set :log_level, :info

# capistrano-db-tasks related
# if you want to remove the dump file after loading
set :db_local_clean, true
# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/assets)
# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
set :locals_rails_env, 'development'

set :passenger_restart_with_touch, true

namespace :deploy do
  desc 'Create chamber.pem symlink'
  task :create_symlink do
    on roles(:app) do
      # Asegurar que shared path y latest release tienen valor/existen
      execute "ln -s #{shared_path}/config/chamber.pem #{release_path}/.chamber.pem"
    end
  end
end

after 'bundler:install', 'deploy:create_symlink'
