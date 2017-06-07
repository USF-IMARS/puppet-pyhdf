class pyhdf {
	#package {'pyhdf-python':
	#	name => 'python',
	#	ensure => '2.6.6-52.el6',
	#}
	class { 'python':
        	version => 'system',
        	dev     => true,
        	pip     => true,
	}
	package {'scipy':
        	ensure => 'present',
	}
        python::pip { 'nose':
                ensure => '1.3.7',
        }
	python::pip { 'numpy':
                before => Package['blas-devel'],
                pkgname => 'numpy',
                ensure => 'latest',
        }

	package {'blas-devel':
		ensure => 'present',
	}
	package {'lapack-devel':
		 require => Package['blas-devel'],
                ensure => 'present',
        }
	package{'numpy-f2py':
		require => Package['lapack-devel'],
		ensure => present,
	}
#	python::pip { 'scipy':
#		require => Package['numpy-f2py'],
#     		pkgname => 'scipy',
#		ensure => 'latest',
#	}
	package {'numpy':
        	ensure => 'present',
	}
	package {'gcc':
		ensure => 'present',
	}
	package {'zlib':
		ensure => 'present',
	}
	package {'libjpeg-turbo':
		ensure => 'present',
	}
	package {'hdf-devel':
		ensure => 'present',
	}
        file { 'pyhdf-source':
                ensure       => 'directory',
                path         => '/root/pyhdf-source',
                recurse      => 'true',
                source       => "puppet:///modules/pyhdf",
                sourceselect => 'all',
		require => Package['hdf-devel']
        }
	exec {"/usr/bin/python setup.py install":
		require => File['pyhdf-source'],
		cwd => '/root/pyhdf-source/pyhdf',
		environment => ['LIBRARY_DIRS=/usr/lib64/hdf', 'INCLUDE_DIRS=/usr/include/hdf', 'NOSZIP=1'],
		logoutput => true,
		creates => '/usr/lib64/python2.6/site-packages/pyhdf-0.8.3-py2.6-linux-x86_64.egg',
	}
}
