#! /usr/bin/perl

use strict;
use warnings;
use File::Basename qw/dirname/;
use Cwd qw/abs_path/;
use feature qw/say/;
use Honeydew::ExternalServices qw/daemonize/;

my $get_bmp_pid = q(ps -ef | awk '/java.*[b]rowsermob/{ print $2 }');

my @pids = split("\n", `$get_bmp_pid`);
say 'bmp pid: ' . $_ for @pids;

# The bmp process when daemonized doesn't respect HUP, INT or QUIT. So
# we're using TERM.
kill 15, @pids if scalar @pids;
say 'Killed other BMP pids...';

my $relative_bmp_binary = 'browsermob-proxy/bin/browsermob-proxy';
my $bmp_binary = abs_path(dirname(__FILE__) . '/' . $relative_bmp_binary);

die 'This is the wrong binary: ' . $bmp_binary
  unless -x $bmp_binary;

my $args = ' --use-littleproxy true ';

# TODO: utilize Honeydew::Config to set this on the correct port
my $restart_cmd = 'JAVACMD=$(which java) ' . $bmp_binary . $args;
say $restart_cmd;

say 'Sleeping a moment to let them die...';
sleep(2);
say 'Starting new BMP process!';
daemonize();
exec( $restart_cmd );
