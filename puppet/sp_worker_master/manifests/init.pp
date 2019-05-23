# ----------------------------------------------------------------------------
#  Copyright (c) 2019 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Class: sp_worker_master
# Init class of stream processor - Worker profile
class sp_worker_master inherits sp_worker_master::params {

  # Create wso2 group
  group { $user_group:
    ensure => present,
    gid    => $user_group_id,
    system => true,
  }

  # Create wso2 user
  user { $user:
    ensure => present,
    uid    => $user_id,
    gid    => $user_group_id,
    home   => "/home/${user}",
    system => true,
  }

  # Create distribution path
  file { [  "${products_dir}",
    "${products_dir}/${product}",
    "${products_dir}/${product}/${product_profile}",
    "${distribution_path}"]:
    ensure => 'directory',
  }

  # Copy binary to distribution path
  file { "binary":
    path   => "${distribution_path}/${product_binary}",
    mode   => '0644',
    source => "puppet:///modules/installers/${product_binary}",
  }

  # Install the "unzip" package
  package { 'unzip':
    ensure => installed,
  }

  # Unzip the binary and create setup
  exec { "unzip-binary":
    command     => "unzip ${product_binary}",
    path        => "/usr/bin/",
    cwd         => $distribution_path,
    onlyif      => "/usr/bin/test ! -d ${install_path}",
    subscribe   => File["binary"],
    refreshonly => true,
    require     => Package['unzip'],
  }

  # Copy deployment.yaml to the installed directory
  file { "${install_path}/${deployment_yaml_template}":
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/carbon-home/${deployment_yaml_template}.erb")
  }

  # Install the "zip" package
  package { 'zip':
    ensure => installed,
  }

  # Copy database connector to the installed directory
  file { "${distribution_path}/${product}-${product_version}/lib/${db_connector}":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/${db_connector}",
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure
    that file is available in modules -> sp_worker_master -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }
}
