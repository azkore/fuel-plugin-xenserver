# We strongly discourage nailgun db modification by plugins
# as this process is very prone to errors and leads to incompatibilities
# If I understand correctly you are making such changes to 
# tweak Fuei UI wizard,

# In Fuel 8 (plugin framework version 4) plugins could change
# wizard components, please see 
# https://github.com/openstack/fuel-plugins/blob/master/examples/fuel_plugin_example_v4/components.yaml
# for an example.


name=${1-"fuel-plugin-xenserver*"}
cd /var/www/nailgun/plugins/%{name}

dockerctl copy cleardb.py nailgun:/tmp/cleardb.py
dockerctl shell nailgun /tmp/cleardb.py
dockerctl shell nailgun rm /tmp/cleardb.py
dockerctl copy xs_release.yaml nailgun:/tmp/xs_release.yaml
dockerctl shell nailgun manage.py loaddata /tmp/xs_release.yaml
dockerctl shell nailgun rm /tmp/xs_release.yaml
fuel rel --sync-deployment-tasks --dir /etc/puppet/
