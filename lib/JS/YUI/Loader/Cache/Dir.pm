package JS::YUI::Loader::Cache::Dir;

use Moose;

use File::Copy qw/copy/;
use Carp::Clan;
use LWP::UserAgent;

has loader => qw/is ro required 1 isa JS::YUI::Loader weak_ref 1/;
has dir => qw/is ro/;

my $agent = LWP::UserAgent->new;

sub BUILD {
    my $self = shift;
    my $given = shift;

    my ($dir) = @$given{qw/dir/};

    croak "Don't have a dir" unless $dir;

    $dir = Path::Class::Dir->new("$dir") unless blessed $dir && $dir->isa("Path::Class");

    $self->{dir} = $dir;
}

sub catalog {
    return shift->loader->catalog;
}

sub _file {
    my $self = shift;
    my $item = shift;
    my $filter = shift;

    my $file = $self->catalog->item($item)->file($filter);
    my $path = $self->dir->file($file);

    unless (-f $path && -s $path) {
        my $source = $self->loader->source;
        if ($source->is_remote) {
            my $uri = $source->uri($item, $filter);
            my $response = $self->request($uri);
            $path->parent->mkpath unless -d $path->parent;
            $path->openw->print($response->content);
        }
        else {
            my $source_file = $source->file($item, $filter);
            copy $source_file, $path or croak "Unable to copy $source_file, $path: $!";
        }
    }

    return ($path, $file);
}

sub file {
    my $self = shift;

    my ($file) = $self->_file(@_);
    return $file;
}

sub request {
    my $self = shift;
    my $uri = shift;
    my $response = $agent->get($uri);

    croak "Didn't get a response for \"$uri\"\n" unless $response;
    croak "Didn't get a successful response for \"$uri\": ", $response->status_line, "\n"  unless $response->is_success;

    return $response;
}

1;
