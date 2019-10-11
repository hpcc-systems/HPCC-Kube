# ConfigMap for HPCC Systems Cluster Configuration

Users can provide customized settings for environment.xml generation through Kubernetes Configmap.

ConfigMap is created with bin/bootstrap-xxx.sh or bin/bootstrap.bat
The files are available on hpcc-admin container under /etc/hpcc-config-map/

Following configurations are availble now
Under hpcc directory:

### topology.properties
This file defines how topology in environment.xml can be constructed

### category.properties
Add/modify Software/Category directories as "-o" option in envgen/envgen2

### override.envgen2
Override all component properties with the given xpath for the given buildset with the value provided. This is "-override" option in envgen/envgen2


### xpath_attributes.envgen2
Sets or adds the xpath attribue and value. This is "-set-xpath-attrib-value" of envgen/envgen2

### [component].envgen2
Add/modify component settings with envgen2 syntax
&lt;HPCC Systems Platform Install Dir&gt;/sbin/envgen2 [-help-update-1 ! -help-update-2] will show some examples

### contents/*.xml
These XML files will be inserted to environment.xml to xpath provided in &lt;!-- XPATH: --&gt; in the file
These files will be sorted first so users can use file names to control the execution order.
