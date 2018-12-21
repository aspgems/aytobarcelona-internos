namespace :deploy do
  desc 'Copy files used per stage to main application dir'
  task :copy_stage_files do
    on roles(:app), in: :parallel do
      files_path = release_path.join("script/deploy/#{fetch(:instance)}/")
      excludes = fetch(:exclude_deployment_files, []).map{|f| "--exclude=#{f}" }.join(' ')
      execute :rsync, '-avcC', excludes, files_path, release_path
    end
  end

  before :updated, :copy_stage_files
end
