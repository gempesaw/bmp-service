#! /usr/bin/perl

use strict;
use warnings;
use Test::Spec;
use Honeydew::ProxyService qw/update_crontab/;

describe 'Proxy crontab entry' => sub {
    my ($crontab);

    before each => sub {
        $crontab = join( "\n", @{ update_crontab() });
    };

    it 'should include a frequent proxy status check' => sub {
        like( $crontab, qr/\*\/5.*bmp-restart check/ );
    };

    it 'should include a nightly forced restart' => sub {
        like( $crontab, qr/\d{2} \d{2}.*bmp-restart/ );
    };
};

runtests;
