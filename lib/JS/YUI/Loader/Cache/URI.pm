package JS::YUI::Loader::Cache::URI;

use Moose;
extends qw/JS::YUI::Loader::Cache::Dir/;

use Path::Abstract;

has uri => qw/is ro/;

sub BUILD {
    my $self = shift;
    my $given = shift;

    my ($dir, $uri);
    if (my $rsc = $given->{rsc}) {
        if (blessed $rsc && $rsc->isa("Path::Resource")) {
            $dir = $rsc->dir;
            $uri = $rsc->uri;
        }
    }
    else {
        ($dir, $uri) = @$given{qw/dir uri/};
    }

    croak "Don't have a dir" unless $dir;
    croak "Don't have a uri" unless $uri;

    $uri = URI->new("$uri") unless blessed $uri && $uri->isa("URI");
    $dir = Path::Class::Dir->new("$dir") unless blessed $dir && $dir->isa("Path::Class");

    $self->{uri} = $uri;
    $self->{dir} = $dir;
}

sub uri {
    my $self = shift;

    my ($path, $file) = $self->_file(@_);
    my $uri = $self->uri->clone;
    $uri->path(Path::Abstract->new($uri->path, "/$file")->stringify);
    return $uri;
}

1;
