# bmp-service

HoneydewSC uses Browsermob Proxy to analyze the traffic that our
tests generate in order to assert tests about analytics and traffic in
general.

This repo stores the current binary of the Browsermob Server, as well
as some crontab scripts to keep it up and running if it happens to
die.

### usage

- `./bmp-update` : build a new browsermob binary
- `./bmp-crontab | crontab`: put the bmp entries into the crontab
- `./bmp-restart`: restart browsermob proxy. The crontab entry uses this file.


### todo

- put the files in bin/ so cpanm will make them available in path ?
