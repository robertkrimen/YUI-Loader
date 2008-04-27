package JS::YUI::Loader::Source::Remote;

use Moose;
extends qw/JS::YUI::Loader::Source/;

sub is_local { return 0 }
sub is_remote { return 1 }

1;
