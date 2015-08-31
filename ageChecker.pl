#!/usr/bin/perl

# Sverre Eldøy 2015
# ageChecker: read data from magStripe debit cards to verify that a person is above a given ageLimit
my $ageLimit = 17;

use Term::ReadKey;
use POSIX;
use Scalar::Util qw(looks_like_number);
ReadMode( raw => STDIN );
my $a = <STDIN>;
ReadMode( restore => STDIN );
print "---------------\n";

my @arra = split("´", $a);
my @card = split("&", $a);

my $expiry = substr $card[2],0, 4;
my $expiryYear = substr $expiry,0,2;
my $expiryMonth = substr $expiry, 2, 2;

if ($#arra eq "6") {
if (looks_like_number($arra[3])) { 

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                          localtime(time);
$year += 1900;
$year -= 2000;
$mon += 1;

my $age = substr $arra[3],0,6;
my $pyear = substr $age, 4, 2;
my $pmonth = substr $age, 2, 2;
my $pday = substr $age, 0,2;

if ($age eq "000000") { print "No age-info on card\n"; }
else {
#print "Year: $pyear Month: $pmonth Day: $pday\n";
#print "Year: $year Month: $mon Day: $mday\n";
my $realAgeYears = (($year - $pyear) + 100);
if ($realAgeYears > 99) { $realAgeYears -= 100; }
my $realAgeMonths = ($mon - $pmonth);
my $realAgeDays = ($mday - $pday);

if (($realAgeMonths < 1) & ($realAgeDays < 0)) {
 $realAgeYears--;
# print "Personen har ikke hatt bursdag i år\n";
}

if (($realAgeMonths < 0)) { $realAgeYears--; $realAgeMonths += 12; }

if (($expiryYear < $year)|($expiryYear<=$year & $expiryMonth<$mon)) {
print "This card has expired! $expiryMonth/$expiryYear\n";
}
else { # card has not expired 
my $realAge = "(YEARS: $realAgeYears, MONTHS: $realAgeMonths)";
if ($realAgeYears > $ageLimit) { print "OK ($realAgeYears)\n";}
else { print "\t!! TOO YOUNG: $realAgeYears\n"; }
}

print "---------------\n";
} # age info was on card

}
else { print "Invalid or unsupported card\n"; }
}
else { print "Not a valid CC/DC\n"; }
