class nginx (
  String	$version           = '1.1.1',
)
{
  package { 'nginx':
    ensure => 'installed',
    name   => 'nginx',
  }

  $os_details = $facts['os']['distro']['description']
  $content    = "OS - $os_details\n"

  file {'/var/www/html/index.html':
    ensure  => file,
    path    => '/var/www/html/index.html',
    mode    => '0644',
    content => epp('nginx/index.html.epp', {'os_details' => $os_details}),
  }

  service { 'nginx':
    ensure => 'running',
    name   => 'nginx',
    enable => true,
  }
}
