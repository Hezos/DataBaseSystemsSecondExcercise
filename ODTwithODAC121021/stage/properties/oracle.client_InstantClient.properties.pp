# The following properties are added to enable OH deinstall tool
oracle.install.customizedeinstall=true
oracle.install.customdeinstallcommand=%ORACLE_HOME%/deinstall/deinstall

# The following property will remove everything from OH during deinstall
oracle.installer.removeallfiles=true

# The following property is added to collapse component list in the Summary page
oracle.installer.summary_expand_nodes=NewLangs,Global,Space,Langs

# This property will give the list of lib extns for which perms are to be set the default value will be =.sl,.sl.11.1 add any other file extns if needed
oracle.installer.LibExtns=.sl,.sl.@<LIBEXTNS_VERSION_NOW>@,.so,.so.@<LIBEXTNS_VERSION_NOW>@,.sl.1.0,.so.1.0

# the explicit permission to be set on lib files default will be 0755
oracle.installer.LibPerms=0755 
