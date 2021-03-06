
Capistrano::Configuration.instance.load do
  namespace :burp do

    desc 'Creates the CMS dir in the shared directory'
    task :setup do
      run "mkdir -p #{shared_path}/cms"
      run "git init #{shared_path}/cms"
    end
    after 'deploy:setup', 'burp:setup'

    desc 'Links the shared CMS dir'  
    task :link_cms_dir do
      run "rmdir #{latest_release}/app/cms; ln -s #{shared_path}/cms #{latest_release}/app/cms"
    end
    after 'deploy:update', 'burp:link_cms_dir'

    desc "Merges the live CMS with the local"
    task :pull, :roles => :web, :once => true do
  
      server = roles[:web].servers.first.host
      user = ssh_options[:user]+"@" || ""
  
      `cd app/cms; git pull #{user}#{server}:#{shared_path}/cms/ master`
    end

    desc "Push local changes to live"
    task :push, :roles => :web, :once => true do
      
      server = roles[:web].servers.first.host
      user = ssh_options[:user]+"@" || ""
      
      `cd app/cms; git push #{user}#{server}:#{shared_path}/cms/ master:local_master`
      
      transaction do
        on_rollback do
          run "cd #{shared_path}/cms; git checkout -f"
          puts "\n\e[0;31m   ######################################################################"
          puts "   #\n   #                  Auto merge faild."
          puts "   #\n   #       Do \"cap burp:pull\" resolve the merge and the try again."
          puts "   #\n"
          puts "   ######################################################################\e[0m\n"
        end
  
        run "cd #{shared_path}/cms; git merge local_master"
      end
      
    end
  end
end
    