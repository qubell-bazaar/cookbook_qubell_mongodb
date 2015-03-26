if (! (node[:mongodb][:replicaset_nodes].length % 2).zero? and node[:mongodb][:replicaset_nodes].length > 1 )
include_recipe "mongodb::replicaset"
else
 include_recipe 'mongodb::mongo_gem'
 Chef::Log.error("Please set odd replicaset members number")
end
