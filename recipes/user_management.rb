require 'resolv'
require 'mongo'
chef_gem 'mongo'

connection = Mongo::Connection.new(node[:fqdn], node[:mongodb][:config][:port], :op_timeout => 5, :slave_ok => true)
if ( connection.primary? == true )
  users = []
  admin = node['mongodb']['admin']

  # If authentication is required,
  # add the admin to the users array for adding/updating
  users << admin if node['mongodb']['config']['auth'] == true

  users.concat(node['mongodb']['users'])

  # Add each user specified in attributes
  users.each do |user|
    mongodb_user user['username'] do
      password user['password']
      roles user['roles']
      database user['database']
      connection node['mongodb']
      action :add
    end
  end
end
mongoset = node[:mongodb][:replicaset_hosts].map {|host| "#{Resolv.getname(host)}:#{node[:mongodb][:config][:port]}"}.join(",")
node.set[:cookbook_qubell_mongodb][:url] = "mongodb://#{node[:mongodb][:users][0][:username]}:#{node[:mongodb][:users][0][:password]}@#{mongoset}/#{node[:mongodb][:users][0][:username]}"
connection.close
