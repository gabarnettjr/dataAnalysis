
package Csv;

eval { use strict;   };
eval { use warnings; };
eval { use FindBin;  };
use lib "$FindBin::Bin";

###############################################################################

sub new
{
	my %self;  my $self = \%self;  bless $self;
	die if scalar @_ != 1;
	$self->setPath(shift);
	return $self;
}

###############################################################################

sub setHeaders
{
	my $self = shift;
	die if scalar @_ != 1;
	my $headers = shift;
	die if ! ref $headers;
	$$self{headers} = $headers;
}



sub headers
{
	my $self = shift;
	die if scalar @_ != 0;
	return $$self{headers} if defined $$self{headers};
	
	(open CSV, "<" . $self->path) || die;
	
	while (<CSV>)
	{
		chomp (my $line = $_);
		
		if ($line =~ /\S+/)
		{
			my @headers = split /\s*\,\s*/, $line;
			close CSV;
			$$self{headers} = \@headers;
			return $$self{headers};
		}
	}
}

###############################################################################

sub setRows
{
	my $self = shift;
	die if scalar @_ != 1;
	my $rows = shift;
	die if ! ref $rows;
	$$self{rows} = $rows;
}



sub rows
{
	my $self = shift;
	die if scalar @_ != 0;
	return $$self{rows} if defined $$self{rows};
	
	(open CSV, "<" . $self->path) || die;
	my @rows = ();
	my $lineNumber = 0;
	
	while (<CSV>)
	{
		chomp (my $line = $_);
		$lineNumber++;
		
		if ($lineNumber != 1 && $line =~ /\S+/)
		{
			my @line = split /\s*\,\s*/, $line;
			my %line;
			
			foreach my $header (@{$self->headers})
			{
				$line{$header} = shift @line;
			}
			
			push @rows, \%line;
		}
	}
	
	close CSV;
	$$self{rows} = \@rows;
	return $$self{rows};
}

###############################################################################

sub setPath
{
	my $self = shift;
	die if scalar @_ != 1;
	my $path = shift;
	die if ! -e $path;
	$$self{path} = $path;
}



sub path
{
	my $self = shift;
	die if scalar @_ != 0;
	return $$self{path} if defined $$self{path};
	die;
}

###############################################################################

sub sortBy
{
	my $self = shift;
	die if scalar @_ != 1;
	my $header = shift;
	
	my $headers = ' ' . (join ' ', @{$self->headers}) . ' ';
	die if $headers !~ /\s+$header\s+/;
	
	my @rows = sort {$$b{$header} <=> $$a{$header}} @{$self->rows};
	$self->setRows(\@rows);
}

###############################################################################

sub print
{
	my $self = shift;
	die if scalar @_ > 1;
	my $filePath = shift;
	die if defined $filePath && ref $filePath;
	my $handle;
	
	if (defined $filePath)
	{
		$handle = 'CSV';
		(open $handle, ">$filePath") || die;
	}
	else
	{
		$handle = 'STDOUT';
	}
	
	print $handle ((join ',', @{$self->headers}) . "\n");
	
	foreach my $row (@{$self->rows})
	{
		my @tmp = ();
		
		foreach my $header (@{$self->headers})
		{
			push @tmp, $$row{$header};
		}
		
		print $handle ((join ',', @tmp) . "\n");
	}
	
	close $handle if defined $filePath;
}

###############################################################################

return 1;

