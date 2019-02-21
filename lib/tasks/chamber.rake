require 'chamber/commands/securable'
require 'chamber/commands/secure'
require 'pathname'

namespace :chamber do

  desc 'Secure all keys from every environment'
  task :secure_all do
    environments = Pathname.new(File.join(Rails.root, 'script', 'deploy')).children.select { |c| c.directory? }.map{|c| c.basename.to_s} << 'development' #nil for development configuration
    environments.each do |environment|
      puts "Securing #{environment || 'development'} environment"
      Rake::Task['chamber:secure'].execute(environment: environment)
    end
  end

  desc 'Secure keys'
  task :secure, [:environment] do |t, args|
    environment = args[:environment] || 'development'

    basepath = environment != 'development' ? File.join(Rails.root, "script", "deploy", "#{environment}", "config") : File.join(Rails.root, "config")
    encryption_key = File.join("#{basepath}", "chamber.pem.pub")
    files = [
        File.join("#{basepath}", "settings.yml"),
        File.join("#{basepath}", "settings", "*.{yml,yml.erb}")
    ]

    puts "Basepath : #{basepath}"
    puts "Encryption_key : #{encryption_key}"
    puts "Files path : #{files}"

    if File.exists? encryption_key
      puts "Encrypting #{environment} environment"
      options = {
          rootpath: Rails.root,
          basepath: basepath,
          encryption_key: encryption_key,
          files: files }

      # system "bundle exec chamber secure --basepath=#{basepath} --encryption-key=#{encryption_key} --files=#{files}"
      chamber_instance = Chamber::Instance.new(options)
      chamber_instance.secure
    else
      puts "No encryption file for #{environment}"
    end

    puts "\n\n"

  end

  def prepare_params(args)
    args.each do |arg|
      task arg.to_sym do ; end
    end
    args
  end

end
