use strict;
use warnings;

use Test::More;
use Test::Deep;
plan qw/no_plan/;

use JS::YUI::Loader;

my $loader = JS::YUI::Loader->new_from_yui_host;
$loader->include->yuitest->reset->fonts->base;
is($loader->html."\n", <<_END_);
<link rel="stylesheet" href="http://yui.yahooapis.com/2.5.1/build/reset/reset.css" type="text/css"/>
<link rel="stylesheet" href="http://yui.yahooapis.com/2.5.1/build/fonts/fonts.css" type="text/css"/>
<link rel="stylesheet" href="http://yui.yahooapis.com/2.5.1/build/base/base.css" type="text/css"/>
<script src="http://yui.yahooapis.com/2.5.1/build/yahoo/yahoo.js" type="text/javascript"></script>
<script src="http://yui.yahooapis.com/2.5.1/build/dom/dom.js" type="text/javascript"></script>
<script src="http://yui.yahooapis.com/2.5.1/build/event/event.js" type="text/javascript"></script>
<script src="http://yui.yahooapis.com/2.5.1/build/logger/logger.js" type="text/javascript"></script>
<script src="http://yui.yahooapis.com/2.5.1/build/yuitest/yuitest.js" type="text/javascript"></script>
_END_
