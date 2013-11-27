class people::jun_chang {
    include macvim_kaoriya

    ## chrome
    include chrome

    ## node
    class { 'nodejs::global': version => 'v0.10.5' }

    ## php
    include openssl
    include php::5_4_17
    include php::5_3_9

    include php::composer

    class { 'php::global':
        version => '5.4.17'
    }

    php::extension::apc { "apc for 5.3.9":
        php     => '5.3.9',
        version => '3.1.13',
    }

    include php::fpm::5_4_17
    include php::fpm::5_3_9

    ## mysql
    mysql::db { 'mydb': }

    ### mongodb
    #include mongodb

    ## zsh
    include zsh

    ## ctags
    include ctags

    ## homebrew
    exec { 'tap-homebrew-dupes':
      command => 'brew tap homebrew/dupes',
      creates => "${homebrew::config::tapsdir}/homebrew-dupes",
    }

    package { [
        'httpd',
        'tig',
        'tmux',
        'tree',
      ]:
      provider => homebrew,
      require  => Exec['tap-homebrew-dupes'],
    }

    ## apps
    include skype
    include virtualbox

    package {
        'mi':
            source   => "http://www.mimikaki.net/download/mi2.1.12r3.dmg",
            provider => pkgdmg;
        'Cyberduck':
            source   => "https://update.cyberduck.io/Cyberduck-4.4.2.zip",
            provider => compressed_app;
    }

    ## settings
    $home     = "/Users/${::luser}"
    $dotfiles = "${home}/dotsfiles"
    exec { "osx-settings":
      cwd => $dotfiles,
      command => "sh ${dotfiles}/osx -s",
    }
}
