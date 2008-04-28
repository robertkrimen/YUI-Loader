use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

use JS::YUI::Loader;

my $loader = JS::YUI::Loader->new_from_yui_host(cache => "t.tmp");
ok($loader);

is($loader->cache->file("yuitest-min"), "t.tmp/yuitest-min.js");
