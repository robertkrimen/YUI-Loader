package JS::YUI::Loader::Source;

use Moose;

has loader => qw/is ro required 1 isa JS::YUI::Loader weak_ref 1/;

sub catalog {
    return shift->loader->catalog;
}

1;
