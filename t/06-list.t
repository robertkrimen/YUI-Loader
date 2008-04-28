use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

use JS::YUI::Loader;

my $loader = JS::YUI::Loader->new_from_yui_host(cache => "t.tmp");
ok($loader->list);

cmp_deeply([ $loader->list->name ], []);

$loader->include->yuitest;
cmp_deeply([ $loader->list->name ], [qw{ yahoo dom event logger yuitest }]);
cmp_deeply([ map { "$_" } $loader->list->item_path ], [qw{ yahoo/yahoo.js dom/dom.js event/event.js logger/logger.js yuitest/yuitest.js }]);

$loader->clear;
$loader->include->imagecropper;
cmp_deeply([ $loader->list->name ], [qw{ yahoo dom event dragdrop element resize imagecropper }]);
cmp_deeply([ map { "$_" } $loader->list->item_path ],
    [qw{ yahoo/yahoo.js dom/dom.js event/event.js dragdrop/dragdrop.js element/element-beta.js resize/resize-beta.js imagecropper/imagecropper-beta.js }]);
