# === Class: windows_chrome::disable
#
# This class removes the installed components.

class windows_chrome::disable (
  $package   = $::windows_chrome::params::package,
) inherits windows_chrome::params {

  package { $package:
    ensure  => absent,
  }

  windows_path { $::chrome_path:
    ensure  => absent,
  }

  file { "${::temp}/${package}.exe":
    ensure  => absent,
  }

}
