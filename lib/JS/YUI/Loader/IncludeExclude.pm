package JS::YUI::Loader::IncludeExclude;

use strict;
use warnings;

use Moose;

has manifest => qw/is ro required 1 weak_ref 1/;
has do_include => qw/is ro required 1/;

# TODO Urgh, ...
for my $component (JS::YUI::Loader::Catalog->name_list) {
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
