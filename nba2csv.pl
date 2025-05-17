
use strict;
use warnings;

die if scalar @ARGV != 1;
my $inPath = shift;

(open NBA, "<$inPath") || die;
my $lineNumber = 0;

while (<NBA>)
{
	chomp (my $line = $_);
	$lineNumber++;
	
	if ($lineNumber == 1)
	{
		my @headers = split /\s+/, $line;
		next;
	}
	
	next if $line !~ /\S+/;
	next if $line =~ /^\d+$/;
	next if $line =~ /Logo$/;
	
	my %row;
	my @line = split /\s+/, $line;
	
	if (scalar @line < 5)
	{
		$row{TEAM} = join ' ', @line;
	}
	else
	{
		foreach my $header (@headers)
		{
			$row{$header} = shift @line;
		}
	}
}

close NBA;