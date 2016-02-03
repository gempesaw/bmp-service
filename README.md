# NAME

Honeydew::ProxyService - A collection of convenience functions for managing Browsermob Proxy

[![Build Status](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService.svg?branch=master)](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService)

# VERSION

version 0.04

# SYNOPSIS

    $ bmp-install          # installs the specified version of Browsermob Proxy
    $ bmp-crontab          # outputs to STDOUT a modified crontab
    $ bmp-restart          # check status, restart if proxy is broken
    $ bmp-restart ANYTHING # force restart of proxy

# DESCRIPTION

HoneydewSC uses Browsermob Proxy to analyze the traffic that our tests
generate in order to assert tests about analytics and traffic in
general.

If you've installed this from Stratopan or CPAN, you should run
`bmp-install` first to get the BMP binaries into your path where this
module expects them. Otherwise, `bmp-restart` won't accomplish
anything - in particular, it won't start up a server because the
server isn't included in the module tarball.

# INSTALLATION

This module is available from Stratopan and can be installed with
`cpanm`. On a new box with no prerequisites, the following should get
you up and running:

    $ curl -L http://cpanmin.us | perl - -l ~/perl5 -nf App::cpanminus local::lib
    $ echo 'eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)' >> ~/.bashrc
    $ echo 'export PATH="$HOME/perl5/bin:$PATH"' >> ~/.bashrc

Then, using the mirror-only options of `cpanm` to install this module
from Stratopan:

    # install dependencies from CPAN
    $ cpanmm --showdeps Honeydew::ProxyService | grep :: | grep -v "Working on" | xargs -I{} cpanm {}
    # install private modules from Stratopan
    $ cpanm --mirror-only --mirror https://<redacted>@stratopan.com/<redacted>/Sharecare/master Honeydew::ProxyService

# BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/honeydew-sc/Honeydew-ProxyService/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# AUTHOR

Daniel Gempesaw <gempesaw@gmail.com>

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2015 by Daniel Gempesaw.

This is free software, licensed under:

    The MIT (X11) License
