#!/usr/bin/perl
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use warnings;
use 5.014;

use Data::Dumper;
use Getopt::Long;
use Pod::Usage;


my %options = ();


# Parses command line options
GetOptions(
	\%options,
	'help',
	'verbose+',
) or pod2usage(
	-verbose => 0,
	-exitval => 2,
);

# Print usage message
pod2usage(
	-verbose => 1,
	-exitval => 2,
) if exists $options{help};



# Parses command line arguments
for (my $i = 0; $i <= $#ARGV; $i++) {
	print "\$ARGV[$i] = ${ARGV[$i]}\n";
}

print Dumper(@ARGV) if $options{verbose};

exit 0;

__END__

=head1 NAME

Perl Script: A Perl script template

=head1 SYNOPSIS

Perl Script [options] [string ...]

=head1 DESCRIPTION

B<Perl Script> parses options and print every string argument one per line.

=head1 OPTIONS

=over 8

=item B<--help>

Print a brief help message and exit.

=item B<--man>

Print the manual page and exits.

=item B<--verbose>


=back

=head1 AUTHORS

=head1 VERSION

=item 2012-09-14

First version of the template

=head1 SEE ALSO

=cut


