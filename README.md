# NAME

Honeydew::ProxyService - A collection of convenience functions for managing Browsermob Proxy

[![Build Status](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService.svg?branch=master)](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService)

# VERSION

version 0.02

# SYNOPSIS

    $ bmp-install # installs the specified version of Browsermob Proxy
    $ bmp-crontab # outputs to STDOUT a modified crontab
    $ bmp-restart # forcefully restarts the browsermob proxy

# DESCRIPTION

HoneydewSC uses Browsermob Proxy to analyze the traffic that our tests
generate in order to assert tests about analytics and traffic in
general.

This repo stores the current binary of the Browsermob Server, as well
as some crontab scripts to keep it up and running if it happens to
die.

If you've installed this from Stratopan or CPAN, you should run
`bmp-install` first to get the BMP binaries into your path where this
module expects them. Otherwise, `bmp-restart` won't accomplish
anything - in particular, it won't start up a server because the
server isn't included in the module tarball due to size constraints.

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
