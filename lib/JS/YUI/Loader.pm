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

use Moose;

use Carp::Clan;
use JS::YUI::Loader::Catalog;

has catalog => qw/is ro required 1 isa JS::YUI::Loader::Catalog lazy 1/, default => sub { shift->source->catalog };
has manifest => qw/is ro required 1 isa JS::YUI::Loader::Manifest lazy 1/, handles => [qw/include exclude select parse schedule/], default => sub {
    my $self = shift;
    require JS::YUI::Loader::Manifest;
    return JS::YUI::Loader::Manifest->new(catalog => $self->catalog, loader => $self);
};
has source => qw/is ro required 1 isa JS::YUI::Loader::Source/;
has cache => qw/is ro isa JS::YUI::Loader::Cache/;
has filter => qw/is rw isa Str/, default => "";

sub filter_min {
    my $self = shift;
    return $self->filter("min");
    return $self;
}

sub filter_debug {
    my $self = shift;
    $self->filter("debug");
    return $self;
}

sub no_filter {
    my $self = shift;
    $self->filter("");
    return $self;
}

sub uri {
    my $self = shift;
    return $self->cache_uri(@_) if $self->cache;
    return $self->source_uri(@_);
}

sub file {
    my $self = shift;
    return $self->cache_file(@_) if $self->cache;
    return $self->source_file(@_);
}

sub cache_uri {
    my $self = shift;
    return $self->cache->uri(@_) or croak "Unable to get uri from cache ", $self->cache;
}

sub cache_file {
    my $self = shift;
    return $self->cache->file(@_) or croak "Unable to get file from cache ", $self->cache;
}

sub source_uri {
    my $self = shift;
    return $self->source->uri(@_) or croak "Unable to get uri from source ", $self->source;
}

sub source_file {
    my $self = shift;
    return $self->source->file(@_) or croak "Unable to get file from source ", $self->source;
}

sub _new_given {
    my $class = shift;
    return @_ == 1 && ref $_[0] eq "HASH" ? shift : { @_ };
}

sub _new_catalog {
    my $class = shift;
    my $given = shift;
    my $catalog = delete $given->{catalog} || {};
    return $given->{catalog} = $catalog if blessed $catalog;
    return $given->{catalog} = JS::YUI::Loader::Catalog->new(%$catalog);
}

sub _build_cache {
    my $class = shift;
    my $given = shift;
    my $source = shift;

    my (%cache, $cache_class);

    if (ref $given eq "ARRAY") {
        $cache_class = "JS::YUI::Loader::Cache::URI";
        my ($uri, $dir) = @$given;
        %cache = (uri => $uri, dir => $dir);
    }
    elsif (ref $given eq "Path::Resource") {
        $cache_class = "JS::YUI::Loader::Cache::URI";
        %cache = (uri => $given->uri, dir => $given->dir);
    }
    else {
        $cache_class = "JS::YUI::Loader::Cache::Dir";
        %cache = (dir => $given);
    }

    eval "require $cache_class;" or die $@;

    return $cache_class->new(source => $source, %cache);
}

sub _new_cache {
    my $class = shift;
    my $given = shift;
    my $source = shift;
    if (my $cache = delete $given->{cache}) {
        $given->{cache} = $class->_build_cache($cache, $source);
    }
}

sub _new_given_catalog {
    my $class = shift;
    my $given = $class->_new_given(@_);

    my $catalog = $class->_new_catalog($given);

    return ($given, $catalog);
}

sub _new_finish {
    my $class = shift;
    my $given = shift;
    my $source = shift;

    $class->_new_cache($given, $source);

    return $class->new(%$given, source => $source);
}

sub new_from_yui_host {
    my $class = shift;

    my ($given, $catalog) = $class->_new_given_catalog(@_);

    my %source;
    $source{version} = delete $given->{version} if exists $given->{version};
    $source{base} = delete $given->{base} if exists $given->{base};
    require JS::YUI::Loader::Source::YUIHost;
    my $source = JS::YUI::Loader::Source::YUIHost->new(catalog => $catalog, %source);

    return $class->_new_finish($given, $source);
}

1;

__END__

sub BUILD {
    my $self = shift;
    my $given = shift;

    if (my $cache = $given->{cache}) {
#        my $cache_class
#        my %cache_new;
        my $_cache;
        $self->{cache} = $_cache;
    }
}

sub new_from_yui_host {
    require JS::YUI::Loader::Source::YUIHost;

    my $class = shift;
    my $given = @_ == 1 && ref $_[0] eq "HASH" ? shift : { @_ };

    my %source;
    $source{version} = delete $given->{version} if exists $given->{version};
    $source{base} = delete $given->{base} if exists $given->{base};
    my $source = JS::YUI::Loader::Source::YUIHost->new(%source);

    return $class->new(source => $source, %$given);
}

sub new_from_yui_dir {
    require JS::YUI::Loader::Source::YUIDir;

    my $class = shift;
    my $given = @_ == 1 && ref $_[0] eq "HASH" ? shift : { @_ };

    my %source;
    $source{version} = delete $given->{version} if exists $given->{version};
    $source{base} = delete $given->{base} if exists $given->{base};
    my $source = JS::YUI::Loader::Source::YUIDir->new(%source);

    return $class->new(source => $source, %$given);
}

sub new_from_dir {
    require JS::YUI::Loader::Source::Dir;

    my $class = shift;
    my $given = @_ == 1 && ref $_[0] eq "HASH" ? shift : { @_ };

    my %source;
    $source{base} = delete $given->{base} if exists $given->{base};
    my $source = JS::YUI::Loader::Source::Dir->new(%source);

    return $class->new(source => $source, %$given);
}

sub new_from_uri {
    require JS::YUI::Loader::Source::URI;

    my $class = shift;
    my $given = @_ == 1 && ref $_[0] eq "HASH" ? shift : { @_ };

    my %source;
    $source{base} = delete $given->{base} if exists $given->{base};
    my $source = JS::YUI::Loader::Source::URI->new(%source);

    return $class->new(source => $source, %$given);
}

1;

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
