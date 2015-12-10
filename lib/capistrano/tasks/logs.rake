namespace :logs do
  desc "tail rails logs"
  task :tail_rails do
    on roles(:app) do
      execute "tail -f #{current_path}/log/puma.error.log"
    end
  end
end
