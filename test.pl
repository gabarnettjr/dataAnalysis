
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin";
use Csv;

my $csv = Csv::new("teamStats.csv");

$csv->sortBy('GP');
$csv->print('sorted.csv');
