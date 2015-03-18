#! /usr/bin/perl

use strict;
use warnings;
use File::Basename qw/dirname/;
use Cwd qw/abs_path/;
use POSIX qw/setsid/;
use feature qw/say/;

my $get_bmp_pid = q(ps -ef | awk '/java.*[b]rowsermob/{ print $2 }');

my @pids = split("\n", `$get_bmp_pid`);
say 'bmp pid: ' . $_ for @pids;

# The bmp process when daemonized doesn't respect HUP, INT or QUIT. So
# we're using TERM.
kill 15, @pids if scalar @pids;

my $relative_bmp_binary = 'browsermob-proxy/bin/browsermob-proxy';
my $bmp_binary = abs_path(dirname(__FILE__) . '/' . $relative_bmp_binary);

die 'This is the wrong binary: ' . $bmp_binary
  unless -x $bmp_binary;

my $restart_cmd = 'JAVACMD=$(which java) nohup ' . $bmp_binary . ' > /dev/null 2>&1 &';
say $restart_cmd;

daemonize();
exec( $restart_cmd );

sub daemonize {
    chdir("/")                      || die "can't chdir to /: $!";
    open(STDIN,  "< /dev/null")     || die "can't read /dev/null: $!";
    open(STDOUT, "> /dev/null")     || die "can't write to /dev/null: $!";
    defined(my $pid = fork())       || die "can't fork: $!";
    exit if $pid;                   # non-zero now means I am the parent
    (setsid() != -1)                || die "Can't start a new session: $!";
    open(STDERR, ">&STDOUT")        || die "can't dup stdout: $!";
}
