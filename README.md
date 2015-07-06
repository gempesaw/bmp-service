# NAME

Honeydew::ProxyService - A collection of convenience functions for managing Browsermob Proxy

[![Build Status](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService.svg?branch=master)](https://travis-ci.org/honeydew-sc/Honeydew-ProxyService)

# VERSION

version 0.01

# SYNOPSIS

    $ bmp-update  # updates to the newest version of Browsermob Proxy from master
    $ bmp-crontab # outputs to STDOUT a modified crontab
    $ bmp-restart # forcefully restarts the browsermob proxy

# DESCRIPTION

HoneydewSC uses Browsermob Proxy to analyze the traffic that our tests
generate in order to assert tests about analytics and traffic in
general.

This repo stores the current binary of the Browsermob Server, as well
as some crontab scripts to keep it up and running if it happens to
die.

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
