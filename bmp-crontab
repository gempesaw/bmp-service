#! /usr/bin/perl

use strict;
use warnings;

use Cwd qw/abs_path/;
use File::Basename qw/dirname/;
use feature qw/say/;
use Honeydew::ExternalServices::Crontab qw/add_crontab_section/;

say $_ for @{ update_crontab() };

sub get_bmp_crontab_entry {
    my $relative_restart = 'restart-bmp.pl';
    my $restart_bmp = abs_path(dirname(__FILE__) . '/' . $relative_restart);

    my $bmp_crontab_entry = qq%# delete orphaned ssl folders older than an hour
0 * * * * find /tmp -name "selenium*" -mmin +60 -exec rm -rf {} \\; > /dev/null 2>&1

# restart the browsermob process if needed
*/5 * * * * if [ \$(ps aux | grep [j]ava.*bmp | wc -l) -eq '0' ]; then $restart_bmp ; fi
%;

    return [ split("\n", $bmp_crontab_entry) ];
}

sub update_crontab {
    return add_crontab_section( 'browsermob', get_bmp_crontab_entry() );

}
