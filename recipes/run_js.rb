require 'resolv'
require 'mongo'

connection = Mongo::Connection.new(node[:fqdn], node[:mongodb][:config][:port], :op_timeout => 5, :slave_ok => true)
if ( connection.primary? == true )
  bash "run_js" do
    cwd "/tmp"
    code <<-EOH
        curl #{node[:cookbook_qubell_mongodb][:script_url]} | LC_ALL=C mongo #{node[:fqdn]}/vermilion 
      EOH
    retries 3
  end
end
connection.close
