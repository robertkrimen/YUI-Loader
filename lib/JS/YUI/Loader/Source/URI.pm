package JS::YUI::Loader::Source::URI;

use Moose;
extends qw/JS::YUI::Loader::Source::Remote/;

use URI;
use Scalar::Util qw/blessed/;

sub BUILD {
    my $self = shift;
    my $given = shift;
    my $base = $given->{base};
    $base = URI->new("$base") unless blessed $base && $base->isa("URI");
}

has base => qw/is ro required 1/;

sub uri {
    my $self = shift;
    my $item = shift;
    my $filter = shift;

    $item = $self->catalog->item($item);
    return $item->file_uri($self->base, $filter);
}

#use LWP::UserAgent;
#my $agent = LWP::UserAgent->new;
#sub request {
#    my $self = shift;
#    my $uri = shift;
#    my $response = $agent->get($uri);

#    warn "Didn't get a response for \"$uri\"\n" and next unless $response;
#    warn "Didn't get a successful response for \"$uri\": ", $response->status_line, "\n"  and next unless $response->is_success;
#}

1;
