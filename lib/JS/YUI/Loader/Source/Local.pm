package JS::YUI::Loader::Source::Local;

use Moose;
extends qw/JS::YUI::Loader::Source/;

sub is_local { return 1 }

sub is_remote { return ! shift->is_local }

1;
