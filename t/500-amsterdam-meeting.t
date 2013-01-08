#! perl
use warnings;
use strict;

use Test::More;
use Test::NoWarnings ();

# tijdreizen is nodig voor het testen van deze module
BEGIN { *CORE::GLOBAL::time = sub { return CORE::time() } }

use Time::Local;

use Amsterdam::Meeting ':all';
{
    no warnings 'redefine';
    my $time;
    local *CORE::GLOBAL::time = sub { return $time };
    my @exceptions = (
        {
            time => timelocal(0, 0, 0, 1, 4, 2009),
            date => '12 mei 2009',
        },
        {
            time => timelocal(0, 0, 0, 13, 4, 2009),
            date => '2 juni 2009',
        },
        {
            time => timelocal(0, 0, 0, 7, 10, 2012),
            date => '4 december 2012',
        },
        {
            time => timelocal(0, 0, 0, 5, 11, 2012),
            date => '8 januari 2013',
        },
    );
    for my $test (@exceptions) {
        $time = $test->{time};
        is(next_amsterdam_meeting(), $test->{date}, $test->{date});
    }
    $time = timelocal(0, 0, 0, 8, 0, 2013) - 7*24*60*60;
    ok(is_amsterdam_announce(), "Announcement day");
}

{
    no warnings 'redefine';
    my $time;
    local *CORE::GLOBAL::time = sub { return $time };
    my @test2012 = (
        { time => [ 0, 2012], date => '3 januari 2012' },
        { time => [ 1, 2012], date => '7 februari 2012' },
        { time => [ 2, 2012], date => '6 maart 2012' },
        { time => [ 3, 2012], date => '3 april 2012' },
        { time => [ 4, 2012], date => '8 mei 2012' },
        { time => [ 5, 2012], date => '5 juni 2012' },
        { time => [ 6, 2012], date => '3 juli 2012' },
        { time => [ 7, 2012], date => '7 augustus 2012' },
        { time => [ 8, 2012], date => '4 september 2012' },
        { time => [ 9, 2012], date => '2 oktober 2012' },
        { time => [10, 2012], date => '6 november 2012' },
        { time => [11, 2012], date => '4 december 2012' },
        { time => [ 0, 2013], date => '8 januari 2013' },
    );
    for my $test (@test2012) {
        $time = amsterdam_meeting_time(@{$test->{time}});
        is(
            next_amsterdam_meeting(),
            $test->{date},
            "check: @{$test->{time}} => $test->{date}"
        );
    }

    my $ts = amsterdam_meeting_time();
    is(
        Amsterdam::Meeting::date_nl($ts),
        $test2012[-1]->{date},
        "amsterdam_meeting_time() [no args]"
    );
}

Test::NoWarnings::had_no_warnings();
done_testing();
