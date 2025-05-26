
use strict;
use warnings;

die if scalar @ARGV != 2;
my $inPath = shift;
my $outPath = shift;

(open NBA, "<$inPath") || die;
my $lineNumber = 0;
my @rows = ();
my @headers;
my @teams = ();

while (<NBA>)
{
	chomp (my $line = $_);
	$lineNumber++;
	
	if ($lineNumber == 1)
	{
		@headers = split /\s+/, $line;
		shift @headers;
		my $pm = pop @headers;
		my $pfd = pop @headers;
		push @headers, "$pfd $pm";
		next;
	}
	
	next if $line !~ /\S+/;
	next if $line =~ /^\s*\d+\s*$/;
	next if $line =~ /Logo$/;
	
	my %row;
	my @line = split /\s+/, $line;
	
	if (scalar @line < 5)
	{
		push @teams, join ' ', @line;
		next;
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
    my @csvRow = (shift @teams);
    
    foreach my $header (@headers)
    {
        push @csvRow, $$row{$header};
    }

    push @csv, (join ',', @csvRow);
}

(open CSV, ">$outPath") || die;
print CSV (join "\n", @csv);
close CSV








