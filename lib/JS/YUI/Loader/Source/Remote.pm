package JS::YUI::Loader::Source::Remote;

use Moose;
extends qw/JS::YUI::Loader::Source/;

sub is_local { return 0 }

sub is_remote { return ! shift->is_local }

1;
