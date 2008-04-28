use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

use JS::YUI::Loader::Catalog;
use JS::YUI::Loader::Manifest;

my $catalog = JS::YUI::Loader::Catalog->new;
my $manifest = JS::YUI::Loader::Manifest->new(catalog => $catalog);
ok($manifest);

$manifest->include->animation->yuitest;

ok($manifest->collection->{animation});
ok($manifest->collection->{yuitest});

$manifest->exclude->animation;

ok(!$manifest->collection->{animation});

$manifest->include->yuitest(0);

ok(!$manifest->collection->{yuitest});

cmp_deeply(scalar $manifest->schedule, []);

$manifest->include->yuitest(1);

cmp_deeply(scalar $manifest->schedule, bag(qw/yahoo dom event logger yuitest/));

$manifest->clear;

cmp_deeply(scalar $manifest->schedule, []);

$manifest->include->reset->fonts->grids->base;

cmp_deeply(scalar $manifest->schedule, [qw/reset fonts grids base/]);

$manifest->include->reset_fonts_grids;

cmp_deeply(scalar $manifest->schedule, [qw/reset fonts grids reset-fonts-grids base/]);

$manifest->exclude->reset->fonts->grids->include->yuitest;

cmp_deeply(scalar $manifest->schedule, [qw/reset-fonts-grids base yahoo dom event logger yuitest/]);
