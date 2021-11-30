class nginx (
  String	$version           = '1.18.0-0ubuntu1.2',
  String        $secretdata        = 'not secret',
)
{
  package { 'nginx':
    ensure => $version,
  }

  $os_details = $facts['os']['distro']['description']
  $content    = "OS - $os_details\n"

  file {'/var/www/html/index.html':
    ensure  => file,
    path    => '/var/www/html/index.html',
    mode    => '0644',
    content => epp('nginx/index.html.epp', {'os_details' => $os_details,'secretdata' => $secretdata}),
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure => 'running',
    name   => 'nginx',
    enable => true,
  }
}
