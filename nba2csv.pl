
use strict;
use warnings;

die if scalar @ARGV != 2;
my $inPath = shift;
my $outPath = shift;

(open NBA, "<$inPath") || die;
my $lineNumber = 0;
my @rows = ();
my @headers;

while (<NBA>)
{
	chomp (my $line = $_);
	$lineNumber++;
	
	if ($lineNumber == 1)
	{
		@headers = split /\s+/, $line;
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
    
    push @rows, \%row;
}

close NBA;

my @csv = (join ',', @headers);

foreach my $row (@rows)
{
    my @csvRow = ();
    
    foreach my $header (@headers)
    {
        push @csvRow, $$row{$header};
    }

    push @csv, (join ',', @csvRow);
}

(open CSV, ">$outPath") || die;
print CSV (join "\n", @csv);
close CSV









