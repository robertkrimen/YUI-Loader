package JS::YUI::Loader::IncludeExclude;

use strict;
use warnings;

use Moose;
use JS::YUI::Loader::Catalog;
use constant Catalog => "JS::YUI::Loader::Catalog";

has manifest => qw/is ro required 1 weak_ref 1/;
has do_include => qw/is ro required 1/;

for my $component (Catalog->names) {
    no strict 'refs';
    *$component = sub {
        my $self = shift;
        my $on = @_ ? shift : $self->do_include;
        if ($on) {
            $self->manifest->collection->{$component} = 1;
            $self->manifest->dirty(1);
        }
        else {
            delete $self->manifest->collection->{$component};
            $self->manifest->dirty(1);
        }
        return $self;
    };
}

sub then {
    return shift->manifest;
}

1;
