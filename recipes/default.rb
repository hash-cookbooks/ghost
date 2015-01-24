#
# Cookbook Name:: ghost
# Recipe:: default
#
# Copyright (C) 2015 Hendrik Schaeidt
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# Create the nodejs user
user node['ghost']['user'] do
  home node['ghost']['home']
end

# Create the nodejs group
group node['ghost']['group'] do
  members node['ghost']['user']
end

# Create the home directory
directory "/srv/ghost" do
  owner     node['ghost']['user']
  group     node['ghost']['group']
  mode      '0755'
  recursive true
end

node.default['nodejs']['version'] = '0.10.26'
include_recipe "nodejs::nodejs_from_binary"
include_recipe "nodejs::npm"
include_recipe "nginx"
include_recipe "supervisor"

#create our nginx proxy template to the configured ghost port
template "#{node.nginx.dir}/sites-available/ghost.conf" do
  source "nginx-ghost.conf.erb"
  mode "0644"
end

#disable default nginx configuration
nginx_site 'default' do
  enable false
end

nginx_site "ghost.conf"

artifact_deploy "ghost" do
  version           node['ghost']['version']
  artifact_location "https://ghost.org/zip/ghost-#{node['ghost']['version']}.zip"
  deploy_to         node['ghost']['home']
  owner             node['ghost']['user']
  group             node['ghost']['group']
  symlinks({
    "log" => "log"
  })
  
  after_deploy Proc.new {
    execute "cd #{node['ghost']['home']}/current && npm install --production"
    
    supervisor_service "ghost" do
      user 'ghost'
      process_name 'ghost'
      command 'npm start'
      directory "#{node['ghost']['home']}/current"
      stdout_logfile '/var/log/ghost.log'
      action [ :enable, :start ]
    end
  }
end