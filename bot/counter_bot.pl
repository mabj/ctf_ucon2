#!/usr/bin/perl
package CounterBot

use strict;
use warnings;
use Data::Dumper;

use constant TRUE 		=> 1;
use constant SLEEP_TIME => 20;

sub self {
	my ($class) = @_;
	my $self = {};
	
	bless($self, $class);
	return $self;
} # self

sub polling_results_dir {
	my ($self) = @_;
} # polling_results_dir

sub compute_results {
	
} # compute_results

sub show_results {
	while (TRUE) {
		sleep SLEEP_TIME;
	}
} # show_results

1;