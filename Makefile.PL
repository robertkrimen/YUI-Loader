use inc::Module::Install;

name     'JS-YUI-Loader';
all_from 'lib/JS/YUI/Loader.pm';
author   'Robert Krimen <rkrimen@cpan.org>';

build_requires 'Test::More';

auto_install;

WriteAll;

