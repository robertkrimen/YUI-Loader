use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

use JS::YUI::Loader::Catalog;
use JS::YUI::Loader::Source::YUIHost;
use JS::YUI::Loader::Source::YUIHost;
use JS::YUI::Loader::Cache::URI;

my $catalog = JS::YUI::Loader::Catalog->new;
my $source = JS::YUI::Loader::Source::YUIHost->new(catalog => $catalog);
my $cache = JS::YUI::Loader::Cache::URI->new(source => $source, dir => "t.tmp", uri => "http://example.com/t");
ok($cache);

is($cache->uri("yuitest"), "http://example.com/t/yuitest.js");
is($cache->uri("yuitest-min"), "http://example.com/t/yuitest-min.js");
is($cache->file("yuitest"), "t.tmp/yuitest.js");
