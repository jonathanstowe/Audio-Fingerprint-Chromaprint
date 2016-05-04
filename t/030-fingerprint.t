#!perl6

use v6.c;

use Test;
use Audio::Sndfile;
use Audio::Fingerprint::Chromaprint;

use LibraryCheck;

if library-exists('chromaprint', v0) {
    my $obj;

    lives-ok { $obj = Audio::Fingerprint::Chromaprint.new }, "create object";

    my $ver;

    lives-ok { $ver = $obj.version() }, "get version";
    diag "testing with $ver";

    my $wav-path = $*PROGRAM.parent.child('data/amen_brother.wav');
    my $wav-obj;
    lives-ok { $wav-obj =  Audio::Sndfile.new(filename => $wav-path, :r) }, "open a wav file for reading";

    lives-ok { $obj.start($wav-obj.samplerate, $wav-obj.channels) }, "start";

    my $r-frames = $wav-obj.frames;
    my ( $data, $frames ) = $wav-obj.read-short($r-frames, :raw);
    lives-ok { $obj.feed($data, $frames) }, "feed $r-frames frames";

    my $rc;
    lives-ok { $rc = $obj.finish }, "finish";
    my $fp;
    ok $rc, "finish was okay";
    lives-ok { $fp = $obj.fingerprint }, "get fingerprint";
    diag $fp;

}
else {
    skip "no libchromaprint can't test";
}



done-testing;
# vim: expandtab shiftwidth=4 ft=perl6
