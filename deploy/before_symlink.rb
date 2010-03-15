begin

  DB_YML_PATH = release_path + "/config/database.yml")
  SCALARIUM_STATE_PATH = "/var/lib/scalarium/cluster_state.json"

  json = File.read(SCALARIUM_STATE_PATH)
  config = ActiveSupport::JSON.decode(json)

  ips_of_database_servers = config['roles']['rails-app']['instances'].map{|instance, instance_config| instance_config['private_dns_name']}

  current_yml = YAML.load(File.read(DB_YML)

  current_yml.update("production_master" => current_yml["production"].dup.update('host' => ips_of_database_servers.first))
  current_yml.update("production_salve" => current_yml["production"].dup.update('host' => ips_of_database_servers.last))

  File.open(DB_YML, "w") do |db|
    db.print current_yml.to_yml
  end
rescue Exception => e
  # we don't want to stop deployment, if you do, don't catch the exception
  puts "Error during creating of data_fabric database.yml"
end