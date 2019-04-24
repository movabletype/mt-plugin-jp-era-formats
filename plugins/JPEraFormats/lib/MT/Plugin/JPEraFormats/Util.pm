package MT::Plugin::JPEraFormats::Util;
use strict;
use warnings;
use utf8;

use Date::Japanese::Era;

use MT;
use MT::Request;
use MT::Util qw( wday_from_ts substr_wref );

sub format_ts {
    my ( $format, $ts, $blog, $lang, $is_mail ) = @_;
    return '' unless defined $ts and $ts ne '';
    my %f;
    unless ($lang) {
        $lang =
            $blog && $blog->date_language
          ? $blog->date_language
          : MT->config->DefaultLanguage;
    }
    if ( $lang eq 'jp' ) {
        $lang = 'ja';
    }
    unless ( defined $format ) {
        $format = $MT::Util::Languages{$lang}[3] || "%B %e, %Y %l:%M %p";
    }
    my $cache = MT->request->cache('formats');
    unless ($cache) {
        MT::Request->instance->cache( 'formats', $cache = {} );
    }
    if ( my $f_ref = $cache->{ $ts . $lang } ) {
        %f = %$f_ref;
    }
    else {
        my $L  = $MT::Util::Languages{$lang};
        my @ts = @f{qw( Y m d H M S )} = map { $_ || 0 } unpack 'A4A2A2A2A2A2',
          $ts;
        $f{w}   = wday_from_ts( @ts[ 0 .. 2 ] );
        $f{j}   = MT::Util::yday_from_ts( @ts[ 0 .. 2 ] );
        $f{'y'} = substr $f{Y}, 2;
        $f{b}   = substr_wref $L->[1][ $f{'m'} - 1 ] || '', 0, 3;
        $f{B}   = $L->[1][ $f{'m'} - 1 ];
        if ( $lang eq 'ja' ) {
            $f{a} = substr $L->[0][ $f{w} ] || '', 0, 1;
        }
        else {
            $f{a} = substr_wref $L->[0][ $f{w} ] || '', 0, 3;
        }
        $f{A} = $L->[0][ $f{w} ];
        ( $f{e} = $f{d} ) =~ s!^0! !;
        $f{I} = $f{H};
        if ( $f{I} > 12 ) {
            $f{I} -= 12;
            $f{p} = $L->[2][1];
        }
        elsif ( $f{I} == 0 ) {
            $f{I} = 12;
            $f{p} = $L->[2][0];
        }
        elsif ( $f{I} == 12 ) {
            $f{p} = $L->[2][1];
        }
        else {
            $f{p} = $L->[2][0];
        }
        $f{I} = sprintf "%02d", $f{I};
        ( $f{k} = $f{H} ) =~ s!^0! !;
        ( $f{l} = $f{I} ) =~ s!^0! !;
        $f{j} = sprintf "%03d", $f{j};
        $f{Z} = '';

        _add_jp_era_formats( \%f );

        $cache->{ $ts . $lang } = \%f;
    }
    my $date_format = $MT::Util::Languages{$lang}->[4] || "%B %e, %Y";
    my $time_format = $MT::Util::Languages{$lang}->[5] || "%l:%M %p";
    $format =~ s!%x!$date_format!g;
    $format =~ s!%X!$time_format!g;
    ## This is a dreadful hack. I can't think of a good format specifier
    ## for "%B %Y" (which is used for monthly archives, for example) so
    ## I'll just hardcode this, for Japanese dates.
    if ( $lang eq 'ja' ) {
        $format =~ s!%B %Y!$MT::Util::Languages{$lang}->[6]!g;
        $format =~ s!%B %E,? %Y!$MT::Util::Languages{$lang}->[4]!ig;
        $format =~ s!%b. %e, %Y!$MT::Util::Languages{$lang}->[4]!ig;
        $format =~ s!%B %E!$MT::Util::Languages{$lang}->[7]!ig;
    }
    elsif ( $lang eq 'it' ) {
        ## Hack for the Italian dates
        ## In Italian, the date always come before the month.
        $format =~ s!%b %e!%e %b!g;
    }
    _replace_jp_era_formats( \$format, \%f );

    $format =~ s!%(\w)!$f{$1}!g if defined $format;

    ## FIXME: This block must go away after Languages hash
    ## removes all of the character references
    if ($is_mail) {
        $format =~ s!&#([0-9]+);!chr($1)!ge;
        $format =~ s!&#[xX]([0-9A-Fa-f]+);!chr(hex $1)!ge;
    }
    $format;
}

sub _add_jp_era_formats {
    my ($f) = @_;
    my $jp_era = Date::Japanese::Era->new( $f->{Y}, $f->{m}, $f->{d} )
      or return;
    $f->{EC} = $jp_era->name;
    $f->{Ey} = $jp_era->year;
    if ( $f->{Ey} == 1 ) {
        $f->{EY} = "$f->{EC}元年";
    }
    else {
        $f->{EY} = "$f->{EC}$f->{Ey}年";
    }
    $f->{EX} = "$f->{H}時$f->{M}分$f->{S}秒";
    $f->{Ex} = "$f->{EY}$f->{m}月$f->{d}日";
    $f->{Ec} = "$f->{Ex} $f->{EX}";
}

sub _replace_jp_era_formats {
    my ( $format, $f ) = @_;
    return unless exists $f->{EC};
    $$format =~ s!%(E[cCxXyY])!$f->{$1}!g if defined $$format;
}

1;

