package JS::YUI::Loader;

use warnings;
use strict;

=head1 NAME

JS::YUI::Loader -

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use constant LATEST_YUI_VERSION => "2.5.1";

use Path::Class;
use Moose;
use LWP::UserAgent;
my $agent = LWP::UserAgent->new;
use URI;

has manifest => qw/is ro required 1 lazy 1/, default => sub {
    return JS::YUI::Loader::Manifest->new;
};

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-js-yui-loader at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=JS-YUI-Loader>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc JS::YUI::Loader


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=JS-YUI-Loader>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/JS-YUI-Loader>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/JS-YUI-Loader>

=item * Search CPAN

L<http://search.cpan.org/dist/JS-YUI-Loader>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of JS::YUI::Loader

__END__

sub manifest {
    my $self = shift;
    my $option = ref $_[0] eq "HASH" ? shift : {};
    my @_manifest = map { split m/\n/ } @_;

    my @manifest;
    for (@_manifest) {
        next if m/^\s*#/;
        next if m/^\s*<!--/;
        next if m/^\s*$/;
        chomp;

        my $item = $_;

        if      ($item =~ m/^\s*<script/) { ($item) = $item =~ m/src="([^"]*)"/ }
        elsif   ($item =~ m/^\s*<link/)   { ($item) = $item =~ m/href="([^"]*)"/ }

        my $uri = URI->new($item);
        push @manifest, $option->{path} ? $uri->path : $uri;
    }

    return wantarray ? @manifest : \@manifest;
}

sub fetch {
    my $self = shift;
    my $option = ref $_[0] eq "HASH" ? shift : { output_dir => "yui" };
    my @manifest = @_;

    my $output_dir = dir $option->{output_dir};
    $output_dir->mkpath unless -d $output_dir;

    my $output_rewrite = $option->{output_rewrite} || sub { $_ };

    @manifest = $self->manifest(@manifest);

    for my $uri (@manifest) {
    
        my $path = $uri->path;
        my $file = $output_dir->file($path);

        unless (-f $file && -s $file) {
            my $response = $agent->get($uri);

            warn "Didn't get a response for \"$uri\"\n" and next unless $response;
            warn "Didn't get a successful response for \"$uri\": ", $response->status_line, "\n"  and next unless $response->is_success;

            {
                local $_ = $file;
                $file = $output_rewrite->($file, $path, $uri); 
            }

            $file->parent->mkpath unless -d $file->parent;
            $file->openw->print($response->content);
        }
    }
}
