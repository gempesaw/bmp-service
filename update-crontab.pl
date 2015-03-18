#! /usr/bin/perl

use strict;
use warnings;
use File::Basename qw/dirname/;
use Cwd qw/abs_path/;
use feature qw/say/;
use Test::More;
use Test::Deep;

sub get_bmp_crontab_entry {
    my $relative_restart = 'restart-bmp.sh';
    my $restart_bmp = abs_path(dirname(__FILE__) . '/' . $relative_restart);

    my $bmp_crontab_entry = qq%
### start: browsermob
05 20 * * * rm -rf /tmp/seleniumSslSupport* > /dev/null 2>&1
*/5 * * * * if [ \$(ps aux | grep [b]rowsermob | wc -l) -eq '0' ]; then $restart_bmp ; fi
### end: browsermob
%;

    return [ split("\n", $bmp_crontab_entry) ];
}

sub remove_existing_entry {
    my ($file) = @_;
    my @current_crontab = @{ _validate_args($file) };

    my @filtered = ();
    my $in_bmp_section = 0;
    foreach my $line (@current_crontab) {
        if ($line =~ /^###.*browsermob$/) {
            $in_bmp_section = !$in_bmp_section;
            next;
        }
        next if $in_bmp_section;

        push @filtered, $line;
    }

    push @filtered, '';

    return \@filtered;
}

sub add_browsermob {
    my ($file) = @_;
    my @current = @{ _validate_args($file) };

    push @current, @{ get_bmp_crontab_entry() }, "";

    return \@current;
}

sub _validate_args {
    my ($maybe_ref) = @_;
    my @array;

    if (ref($maybe_ref) eq 'ARRAY') {
        @array = @$maybe_ref;
    }
    else {
        @array = split("\n", `crontab -l`);
    }

    return \@array;
}

sub update_crontab {
    my $filtered_crontab = remove_existing_entry();
    my $updated_crontab = add_browsermob($filtered_crontab);

    say $_ for @$updated_crontab;
}

update_crontab();

# tests
SKIP: {
    skip 'tests are diagnostic', 1 unless @ARGV;

    my @fake_crontab = @{ get_bmp_crontab_entry() };
    unshift @fake_crontab, 'first';
    push @fake_crontab, 'last';

  REMOVE_EXISTING: {
        my @fake = @fake_crontab;


        my $filtered = remove_existing_entry(\@fake);

        cmp_deeply( $filtered, [
            'first',
            '',
            'last',
            ''
        ], 'Can remove browsermob entries');
        ok($filtered->[-1] eq '', 'Removal put an empty line at the end of the crontab');
    }

  ADD_NEW: {
        my @fake = @fake_crontab;
        my $updated = add_browsermob(@fake);

        my $updated_string = join('', @$updated);
        ok($updated_string =~ /### start: browsermob.*### end: browsermob/,
           'updated crontab has our BMP entries');
        is($updated->[-1], '', 'Addition ensures an empty line at the end of the crontab');
    }

    done_testing;
}
