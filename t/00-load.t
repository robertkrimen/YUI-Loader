#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'YUI::Loader' );
}

diag( "Testing YUI::Loader $YUI::Loader::VERSION, Perl $], $^X" );
