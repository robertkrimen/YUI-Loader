use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

ok(1)

__END__

use JS::YUI::Loader::Manifest;
use JS::YUI::Loader::Catalog;
use JS::YUI::Loader::Source::YUIHost;
my $source_yuihost = JS::YUI::Loader::Source::YUIHost->new;
use JS::YUI::Loader::Source::YUIDir;
my $source_yuidir = JS::YUI::Loader::Source::YUIDir->new(base => "yui/build");

use constant Catalog => "JS::YUI::Loader::Catalog";
my $manifest = JS::YUI::Loader::Manifest->new;
ok($manifest);

$manifest->include->animation->yuitest;

ok($manifest->collection->{animation});
ok($manifest->collection->{yuitest});

$manifest->exclude->animation;

ok(!$manifest->collection->{animation});

$manifest->include->yuitest(0);

ok(!$manifest->collection->{yuitest});

cmp_deeply(scalar $manifest->list, []);

$manifest->include->yuitest(1);

cmp_deeply(scalar $manifest->list, bag(qw/yahoo dom event logger yuitest /));

is(Catalog->item("yuitest")->file, "yuitest.js");
is(Catalog->item("yuitest")->file("min"), "yuitest-min.js");
is(Catalog->item("yuitest")->file("debug"), "yuitest-debug.js");
is(Catalog->item("imagecropper")->file, "imagecropper-beta.js");
is(Catalog->item("imagecropper")->file("min"), "imagecropper-beta-min.js");
is(Catalog->item("imagecropper")->file("debug"), "imagecropper-beta-debug.js");

is($source_yuihost->uri("yuitest"), "http://yui.yahooapis.com/2.5.1/build/yuitest/yuitest.js");
is($source_yuihost->uri("yuitest", "min"), "http://yui.yahooapis.com/2.5.1/build/yuitest/yuitest-min.js");
is($source_yuihost->uri("imagecropper"), "http://yui.yahooapis.com/2.5.1/build/imagecropper/imagecropper-beta.js");
is($source_yuihost->uri("imagecropper", "min"), "http://yui.yahooapis.com/2.5.1/build/imagecropper/imagecropper-beta-min.js");

is($source_yuidir->file("yuitest"), "yui/build/yuitest/yuitest.js");
is($source_yuidir->file("yuitest", "min"), "yui/build/yuitest/yuitest-min.js");
is($source_yuidir->file("imagecropper"), "yui/build/imagecropper/imagecropper-beta.js");
is($source_yuidir->file("imagecropper", "min"), "yui/build/imagecropper/imagecropper-beta-min.js");

my $loader = JS::YUI::Loader->new_from_yui_host(cache => ".");

is($loader->cache->file("yuitest", "min"), "min");

1;
