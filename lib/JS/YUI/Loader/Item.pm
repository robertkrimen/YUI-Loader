package JS::YUI::Loader::Item;

use Moose;
use Path::Abstract;
use Carp;

has name => qw/is ro required 1 isa Str/;
has type => qw/is ro required 1 isa Str/;
has _path => qw/is ro required 1 isa Path::Abstract/;
has _file => qw/is ro required 1 isa Str lazy 1/, default => sub {
    my $self = shift;
    $self->_path->last;
};

sub parse {
    my $class = shift;
    my $name = shift;
    my $given = shift;
    my $path = $given->{path};
    $path =~ s/-min\b//;
    return $class->new(name => $name, type => $given->{type}, _path => Path::Abstract->new($path));
}

sub _filter ($$) {
    my $path = shift;
    my $filter = shift;

    $path =~ s/(.*)(\..{2,4})$/$1-$filter$2/ or croak "Don't understand path \"$path\"";

    return $path;
}

sub _filter_path ($$) {
    my $path = shift;
    my $filter = shift;

    return $path unless $filter;

    $filter =~ m/^\s*min\s*$/i and return _filter $path, "min";
    $filter =~ m/^\s*debug\s*$/i and return _filter $path, "debug";

    return $path;
}

sub file {
    my $self = shift;
    my $filter = shift;
    return _filter_path $self->_file, $filter;
}

sub path {
    my $self = shift;
    my $filter = shift;
    return _filter_path $self->_path, $filter;
}

sub _uri ($$) {
    my $base = shift;
    my $path = shift;

    my $uri = $base->clone;
    $uri->path(Path::Abstract->new($uri->path, "/$path")->stringify);
    return $uri;
}

sub file_uri {
    my $self = shift;
    my $base = shift;
    my $filter = shift;
    return _uri $base, $self->file($filter);
}

sub path_uri {
    my $self = shift;
    my $base = shift;
    my $filter = shift;
    return _uri $base, $self->path($filter);
}

1;
