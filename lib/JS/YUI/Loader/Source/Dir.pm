package JS::YUI::Loader::Source::Dir;

use Moose;
extends qw/JS::YUI::Loader::Source/;

has dir => qw/is ro required 1/;

sub BUILD {
    my $self = shift;
    my $given = shift;
    my $dir = $given->{dir};
    $self->{dir} = Path::Class::Dir->new($dir);
}

override file => sub {
    my $self = shift;
    my $item = shift;
    my $filter = shift;

    $item = $self->catalog->item($item);
    return $self->base->file($item->file($filter));
};

1;
