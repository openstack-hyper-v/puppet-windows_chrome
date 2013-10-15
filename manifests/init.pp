# === Class: windows_chrome
#
# This module installs Chrome on Windows systems. It also adds an entry to the
# PATH environment variable.
#
# === Parameters
#
# [*url*]
#   HTTP url where the installer is available. It defaults to main site.
# [*package*]
#   Package name in the system.
# [*file_path*]
#   This parameter is used to specify a local path for the installer. If it is
#   set, the remote download from $url is not performed. It defaults to false.
#
# === Examples
#
# class { 'windows_chrome': }
#
# class { 'windows_chrome':
#   $url     => 'http://192.168.1.1/files/chrome.exe',
#   $package => 'Google Chrome',
# }
#
# === Authors
# 
#
class windows_chrome (
  $url       = $::windows_chrome::params::url,
  $package   = $::windows_chrome::params::package,
  $file_path = false,
) inherits windows_chrome::params {

  if $file_path {
    $chrome_installer_path = $file_path
  } else {
    $chrome_installer_path = "${::temp}\\${package}.exe"
    windows_common::remote_file{'Chrome':
      source      => $url,
      destination => $chrome_installer_path,
      before      => Package[$package],
    }
  }
  package { $package:
    ensure          => installed,
    source          => $chrome_installer_path,
    install_options => ['/VERYSILENT','/SUPPRESSMSGBOXES','/LOG'],
  }

  $chrome_path = 'C:\Program Files (x86)\Google\Chrome\Application'
 
  windows_path { $chrome_path:
    ensure  => present,
    require => Package[$package],
  }
}
