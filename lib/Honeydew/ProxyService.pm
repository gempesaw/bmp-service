package Honeydew::ProxyService;

# ABSTRACT: A collection of convenience functions for managing Browsermob Proxy
require Exporter;
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw/update_crontab
                    restart_bmp_process/;

use Cwd qw/abs_path/;
use File::Basename qw/dirname/;
use File::Spec;
use feature qw/say/;
use Browsermob::Proxy;
use Honeydew::Config;
use Honeydew::ExternalServices qw/daemonize/;
use Honeydew::ExternalServices::Crontab qw/add_crontab_section/;

=for markdown [![Build Status](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService.svg?branch=master)](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService)

=head1 SYNOPSIS

    $ bmp-install # installs the specified version of Browsermob Proxy
    $ bmp-crontab # outputs to STDOUT a modified crontab
    $ bmp-restart # forcefully restarts the browsermob proxy

=head1 DESCRIPTION

HoneydewSC uses Browsermob Proxy to analyze the traffic that our tests
generate in order to assert tests about analytics and traffic in
general.

This repo stores the current binary of the Browsermob Server, as well
as some crontab scripts to keep it up and running if it happens to
die.

If you've installed this from Stratopan or CPAN, you should run
C<bmp-install> first to get the BMP binaries into your path where this
module expects them. Otherwise, C<bmp-restart> won't accomplish
anything - in particular, it won't start up a server because the
server isn't included in the module tarball due to size constraints.

=head1 INSTALLATION

This module is available from Stratopan and can be installed with
C<cpanm>. On a new box with no prerequisites, the following should get
you up and running:

    $ curl -L http://cpanmin.us | perl - -l ~/perl5 -nf App::cpanminus local::lib
    $ echo 'eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)' >> ~/.bashrc
    $ echo 'export PATH="$HOME/perl5/bin:$PATH"' >> ~/.bashrc

Then, using the mirror-only options of C<cpanm> to install this module
from Stratopan:

    # install dependencies from CPAN
    $ cpanmm --showdeps Honeydew::ProxyService | grep :: | grep -v "Working on" | xargs -I{} cpanm {}
    # install private modules from Stratopan
    $ cpanm --mirror-only --mirror https://<redacted>@stratopan.com/<redacted>/Sharecare/master Honeydew::ProxyService

=cut

sub update_crontab {
    return add_crontab_section( 'browsermob', _get_bmp_crontab_entry() );
}

sub _get_bmp_crontab_entry {
    my $restart_bmp = 'bmp-restart';

    my $bmp_crontab_entry = qq%# restart the browsermob process if needed
*/5 * * * * source ~/.bashrc; $restart_bmp check_status

# force a restart every night before the nightlies
55 19 * * * source ~/.bashrc; $restart_bmp
%;

    return [ split("\n", $bmp_crontab_entry) ];
}

sub check_bmp_status {
    my %args = ( port => 65432 );
    # The BMP module should forcibly throw if anything goes wrong, so
    # if we make it out of this sub, we should be fine. Also, when the
    # C<$proxy> object goes out of scope, it will call delete on its
    # own, so we're test creation and deletion in the next two lines.
    my $bmp_status = 0;
    eval {
        my $proxy = Browsermob::Proxy->new( %args );
        $bmp_status = !!$proxy;
    };

    return $bmp_status;
}

sub restart_bmp_process {
    my ($check_status_first) = @_;

    if ($check_status_first) {
        my $isProxyWorking = check_bmp_status();
        if ($isProxyWorking) {
            say 'Proxy Server can create and delete proxies';
            return 1;
        }
        else {
            say 'Proxy server is not working; going ahead and making you a new one...';
        }
    }

    _kill_existing_bmp_process();

    my $restart_cmd = _get_bmp_start_command();
    start_new_bmp( $restart_cmd );
}

sub _kill_existing_bmp_process {
    my $get_bmp_pid = q(ps -ef | awk '/java.*[b]rowsermob/{ print $2 }');

    my @pids = split("\n", `$get_bmp_pid`);
    if (scalar @pids) {
        say 'bmp pid: ' . $_ for @pids;

        # The bmp process when daemonized doesn't respect HUP, INT or QUIT. So
        # we're using TERM.
        kill 15, @pids if scalar @pids;
        say 'Killed other BMP pids...';
    }
    else {
        say 'No BMP processes to kill.';
    }
}

sub _get_bmp_binary {
    my $relative_bmp_binary = 'ProxyService/browsermob-proxy/bin/browsermob-proxy';
    my $bmp_binary = abs_path(dirname(__FILE__) . '/' . $relative_bmp_binary);

    die 'This is the wrong binary: ' . $bmp_binary
      unless -x $bmp_binary;

    return $bmp_binary;
}

sub _get_bmp_start_command {
    my $bmp_binary = _get_bmp_binary();
    my $args = _bmp_process_args();

    # TODO: utilize Honeydew::Config to set this on the correct port
    my $restart_cmd = 'JAVACMD=$(which java) PATH=/usr/bin:$PATH ' . $bmp_binary . $args;
    say $restart_cmd;

    return $restart_cmd;
}

sub _bmp_process_args {
    my $port = 8080;
    eval {
        my $config = Honeydew::Config->instance;
        if (exists $config->{proxy}->{proxy_server_port}) {
            $port = $config->{proxy}->{proxy_server_port};
        }
    };

    my $args = ' --use-littleproxy true ';
    $args .= " --port=$port";

    return $args;
}

sub start_new_bmp {
    my ($cmd) = @_;

    say 'Sleeping a moment to let them die...';
    sleep(2);
    say 'Starting new BMP process!';
    daemonize();
    exec( $cmd );
}

1;
