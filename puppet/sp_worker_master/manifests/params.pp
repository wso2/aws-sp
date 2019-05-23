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

# Claas sp_worker_master::params
# This class includes all the necessary parameters
class sp_worker_master::params {
  $user = 'wso2carbon'
  $user_group = 'wso2'
  $product = 'wso2sp'
  $product_version = '4.4.0'
  $product_profile = 'worker'
  $user_id = 802
  $ports_offset = 0
  $user_home = '/home/$user'
  $user_group_id = 802
  $enable_test_mode = 'ENABLE_TEST_MODE'
  $hostname = 'localhost'
  $mgt_hostname = 'localhost'
  $db_managment_system = 'CF_DBMS'
  $oracle_sid = 'WSO2SPDB'
  $db_password = 'CF_DB_PASSWORD'
  $ei_package = 'wso2sp-4.4.0.zip'

  # Define the template
  $deployment_yaml_template = "conf/${product_profile}/deployment.yaml"

  # -------- deployment.yaml configs --------

  # listenerConfigurations
  $default_host = '0.0.0.0'
  $msf4j_host = '0.0.0.0'
  $msf4j_keystore_file = '${carbon.home}/resources/security/wso2carbon.jks'
  $msf4j_keystore_password = 'wso2carbon'
  $msf4j_cert_pass = 'wso2carbon'

  $siddhi_default_host = '0.0.0.0'
  $siddhi_msf4j_host = '0.0.0.0'
  $siddhi_msf4j_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $siddhi_msf4j_keystore_password = 'wso2carbon'
  $siddhi_msf4j_cert_pass = 'wso2carbon'

  # Datasource Configurations
  $carbon_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/WSO2_CARBON_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000'
  $carbon_db_username = 'wso2carbon'
  $carbon_db_password = 'wso2carbon'
  $carbon_db_dirver = 'org.h2.Driver'

  # Cluster Configuration
  $cluster_enabled = 'false'

  if $db_managment_system == 'mysql' {
    $sp_analytics_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $sp_analytics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/SP_ANALYTICS_DB?useSSL=false'
    $persistence_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_PERSISTENCE_DB?useSSL=false'
    $db_driver_class_name = 'com.mysql.jdbc.Driver'
    $db_connector = 'mysql-connector-java-5.1.41-bin.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system =~ 'oracle' {
    $sp_analytics_db_username = 'SP_ANALYTICS_DB'
    $persistence_db_username = 'WSO2_PERSISTENCE_DB'
    $sp_analytics_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $persistence_db_url = "jdbc:oracle:thin:@CF_RDS_URL:1521/${oracle_sid}"
    $db_driver_class_name = 'oracle.jdbc.OracleDriver'
    $db_validation_query = 'SELECT 1 FROM DUAL'
    $db_connector = 'ojdbc8_1.0.0.jar'

  } elsif $db_managment_system == 'sqlserver-se' {
    $sp_analytics_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $sp_analytics_db_url =
      'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=SP_ANALYTICS_DB;SendStringParametersAsUnicode=false'
    $persistence_db_url =
      'jdbc:sqlserver://CF_RDS_URL:1433;databaseName=WSO2_PERSISTENCE_DB;SendStringParametersAsUnicode=false'
    $db_driver_class_name = 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
    $db_connector = 'mssql-jdbc-7.0.0.jre8.jar'
    $db_validation_query = 'SELECT 1'

  } elsif $db_managment_system == 'postgres' {
    $sp_analytics_db_username = 'CF_DB_USERNAME'
    $persistence_db_username = 'CF_DB_USERNAME'
    $sp_analytics_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/SP_ANALYTICS_DB'
    $persistence_db_url = 'jdbc:postgresql://CF_RDS_URL:5432/WSO2_PERSISTENCE_DB'
    $db_driver_class_name = 'org.postgresql.Driver'
    $db_connector = 'postgresql-42.2.5.jar'
    $db_validation_query = 'SELECT 1; COMMIT'
  }

  $sp_analytics_db = {
    url               => $sp_analytics_db_url,
    username          => $sp_analytics_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  $persistence_db = {
    url               => $persistence_db_url,
    username          => $persistence_db_username,
    password          => $db_password,
    driver_class_name => $db_driver_class_name,
    validation_query  => $db_validation_query,
  }

  # Directories
  $products_dir = "/usr/local/wso2"

  # Product and installation paths
  $product_binary = "${product}-${product_version}.zip"
  $distribution_path = "${products_dir}/${product}/${product_profile}/${product_version}"
  $install_path = "${distribution_path}/${product}-${product_version}"
}
