
use v6.c;
use NativeCall;

class Audio::Fingerprint::Chromaprint {

    constant LIB = [ 'chromaprint', v0 ];

## Enumerations

# == /usr/include/chromaprint.h ==

    enum Algorithm ( Test1 => 0, Test2 => 1, Test3 => 2, Test4 => 3);

## Structures


# == <builtin> ==

class __va_list_tag_c is repr('CStruct') is export {
	has uint32                        $.gp_offset; # unsigned int gp_offset
	has uint32                        $.fp_offset; # unsigned int fp_offset
	has Pointer                       $.overflow_arg_area; # void* overflow_arg_area
	has Pointer                       $.reg_save_area; # void* reg_save_area
}
## Extras stuff

constant __va_list_tag is export := __va_list_tag_c;
## Functions


# == /usr/include/chromaprint.h ==

#-From /usr/include/chromaprint.h:64
#/**
# * Return the version number of Chromaprint.
# */
#CHROMAPRINT_API const char *chromaprint_get_version(void);

    sub chromaprint_get_version() returns Str is native(LIB) { * }

    method version() returns Str {
        chromaprint_get_version();
    }

#-From /usr/include/chromaprint.h:81
#/**
# * Allocate and initialize the Chromaprint context.
# *
# * Note that when Chromaprint is compiled with FFTW, this function is
# * not reentrant and you need to call it only from one thread at a time.
# * This is not a problem when using FFmpeg or vDSP.
# *
# * Parameters:
# *  - version: Version of the fingerprint algorithm, use
# *             CHROMAPRINT_ALGORITHM_DEFAULT for the default
# *             algorithm
# *
# * Returns:
# *  - Chromaprint context pointer
# */
#CHROMAPRINT_API ChromaprintContext *chromaprint_new(int algorithm);

    class Context is repr('CPointer') {

        sub chromaprint_new(int32 $algorithm) returns Context is native(LIB)  { * }

        method new(Context:U: Algorithm :$algorithm = Test2) returns Context {
            chromaprint_new($algorithm.Int);
        }

#-From /usr/include/chromaprint.h:93
#/**
# * Deallocate the Chromaprint context.
# *
# * Note that when Chromaprint is compiled with FFTW, this function is
# * not reentrant and you need to call it only from one thread at a time.
# * This is not a problem when using FFmpeg or vDSP.
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# */
#CHROMAPRINT_API void chromaprint_free(ChromaprintContext *ctx);

        sub chromaprint_free(Context $ctx) is native(LIB) { * }

        method free(Context:D:) {
            chromaprint_free(self);
        }

#-From /usr/include/chromaprint.h:98
#/**
# * Return the fingerprint algorithm this context is configured to use.
# */
#CHROMAPRINT_API int chromaprint_get_algorithm(ChromaprintContext *ctx);

        sub chromaprint_get_algorithm(Context $ctx ) is native(LIB) returns int32 { * }

        method algorithm(Context:D:) returns Algorithm {
            my $alg = chromaprint_get_algorithm(self);
            Algorithm($alg);
        }

#-From /usr/include/chromaprint.h:117
#/**
# * Set a configuration option for the selected fingerprint algorithm.
# *
# * NOTE: DO NOT USE THIS FUNCTION IF YOU ARE PLANNING TO USE
# * THE GENERATED FINGERPRINTS WITH THE ACOUSTID SERVICE.
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *  - name: option name
# *  - value: option value
# *
# * Possible options:
# *  - silence_threshold: threshold for detecting silence, 0-32767
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_set_option(ChromaprintContext *ctx, const char *name, int value);

        sub chromaprint_set_option(Context  $ctx, Str $name, int32 $value ) is native(LIB) returns int32 { * }

        method silence-threshold(Context:D: Int $threshold) returns Bool {
            my $rc = chromaprint_set_option(self, 'silence_threshold', $threshold);
            Bool($rc);
        }

#-From /usr/include/chromaprint.h:130
#/**
# * Restart the computation of a fingerprint with a new audio stream.
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *  - sample_rate: sample rate of the audio stream (in Hz)
# *  - num_channels: numbers of channels in the audio stream (1 or 2)
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_start(ChromaprintContext *ctx, int sample_rate, int num_channels);

        sub chromaprint_start(Context $ctx, int32  $sample_rate, int32 $num_channels ) is native(LIB) returns int32 { * }

        method start(Context:D: Int $sample-rate, Int $channels) returns Bool {
            my $rc = chromaprint_start(self, $sample-rate, $channels);
            Bool($rc);
        }

#-From /usr/include/chromaprint.h:144
#/**
# * Send audio data to the fingerprint calculator.
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *  - data: raw audio data, should point to an array of 16-bit signed
# *          integers in native byte-order
# *  - size: size of the data buffer (in samples)
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_feed(ChromaprintContext *ctx, void *data, int size);

        sub chromaprint_feed(Context $ctx, CArray[int16] $data, int32 $size ) is native(LIB) returns int32 { * }

        method feed(Context:D: CArray $data, Int $frames) returns Bool {
            my $rc = chromaprint_feed(self, $data, $frames);
            Bool($rc);
        }

#-From /usr/include/chromaprint.h:155
#/**
# * Process any remaining buffered audio data and calculate the fingerprint.
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_finish(ChromaprintContext *ctx);

        sub chromaprint_finish(Context $ctx ) is native(LIB) returns int32 { * }

        method finish(Context:D:) returns Bool {
            my $rc = chromaprint_finish(self);
            Bool($rc);
        }

#-From /usr/include/chromaprint.h:171
#/**
# * Return the calculated fingerprint as a compressed string.
# *
# * The caller is responsible for freeing the returned pointer using
# * chromaprint_dealloc().
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *  - fingerprint: pointer to a pointer, where a pointer to the allocated array
# *                 will be stored
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_get_fingerprint(ChromaprintContext *ctx, char **fingerprint);

        sub chromaprint_get_fingerprint(Context $ctx, Pointer[Str]  $fingerprint is rw ) is native(LIB) returns int32  { * }

        method fingerprint(Context:D:) returns Str {
            my $p = Pointer[Str].new;
            my $rc = chromaprint_get_fingerprint(self, $p);
            my $ret = $p.deref.encode.decode;

            self.dealloc($p);

            $ret;
        }

#-From /usr/include/chromaprint.h:188
#/**
# * Return the calculated fingerprint as an array of 32-bit integers.
# *
# * The caller is responsible for freeing the returned pointer using
# * chromaprint_dealloc().
# *
# * Parameters:
# *  - ctx: Chromaprint context pointer
# *  - fingerprint: pointer to a pointer, where a pointer to the allocated array
# *                 will be stored
# *  - size: number of items in the returned raw fingerprint
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_get_raw_fingerprint(ChromaprintContext *ctx, void **fingerprint, int *size);

        sub chromaprint_get_raw_fingerprint(Context $ctx, Pointer[Pointer] $fingerprint, Pointer[int32] $size ) is native(LIB) returns int32 { * }

#-From /usr/include/chromaprint.h:213
#/**
# * Compress and optionally base64-encode a raw fingerprint
# *
# * The caller is responsible for freeing the returned pointer using
# * chromaprint_dealloc().
# *
# * Parameters:
# *  - fp: pointer to an array of 32-bit integers representing the raw
# *        fingerprint to be encoded
# *  - size: number of items in the raw fingerprint
# *  - algorithm: Chromaprint algorithm version which was used to generate the
# *               raw fingerprint
# *  - encoded_fp: pointer to a pointer, where the encoded fingerprint will be
# *                stored
# *  - encoded_size: size of the encoded fingerprint in bytes
# *  - base64: Whether to return binary data or base64-encoded ASCII data. The
# *            compressed fingerprint will be encoded using base64 with the
# *            URL-safe scheme if you set this parameter to 1. It will return
# *            binary data if it's 0.
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_encode_fingerprint(const void *fp, int size, int algorithm, void **encoded_fp, int *encoded_size, int base64);

        sub chromaprint_encode_fingerprint(Pointer $fp, int32 $size, int32 $algorithm, Pointer[Pointer] $encoded_fp, Pointer[int32] $encoded_size, int32 $base64 ) is native(LIB) returns int32 { * }

#-From /usr/include/chromaprint.h:236
#/**
# * Uncompress and optionally base64-decode an encoded fingerprint
# *
# * The caller is responsible for freeing the returned pointer using
# * chromaprint_dealloc().
# *
# * Parameters:
# *  - encoded_fp: Pointer to an encoded fingerprint
# *  - encoded_size: Size of the encoded fingerprint in bytes
# *  - fp: Pointer to a pointer, where the decoded raw fingerprint (array
# *        of 32-bit integers) will be stored
# *  - size: Number of items in the returned raw fingerprint
# *  - algorithm: Chromaprint algorithm version which was used to generate the
# *               raw fingerprint
# *  - base64: Whether the encoded_fp parameter contains binary data or
# *            base64-encoded ASCII data. If 1, it will base64-decode the data
# *            before uncompressing the fingerprint.
# *
# * Returns:
# *  - 0 on error, 1 on success
# */
#CHROMAPRINT_API int chromaprint_decode_fingerprint(const void *encoded_fp, int encoded_size, void **fp, int *size, int *algorithm, int base64);

        sub chromaprint_decode_fingerprint(Pointer  $encoded_fp, int32 $encoded_size, Pointer[Pointer] $fp, Pointer[int32] $size, Pointer[int32] $algorithm, int32 $base64 ) is native(LIB) returns int32 { * }

#-From /usr/include/chromaprint.h:244
#/**
# * Free memory allocated by any function from the Chromaprint API.
# *
# * Parameters:
# *  - ptr: Pointer to be deallocated
# */
#CHROMAPRINT_API void chromaprint_dealloc(void *ptr);

        sub chromaprint_dealloc_p(Pointer $ptr ) is symbol('chromaprint_dealloc') is native(LIB) { * }
        sub chromaprint_dealloc_s(Str $ptr ) is symbol('chromaprint_dealloc') is native(LIB) { * }

        multi method dealloc(Pointer $ptr) {
            chromaprint_dealloc_p($ptr);
        }
        multi method dealloc(Str $ptr) {
            chromaprint_dealloc_s($ptr);
        }
    }

    has Context $!context handles <start feed finish fingerprint>;

    has Bool $!started = False;

    submethod BUILD() {
        $!context = Context.new;
    }

}
# vim: expandtab shiftwidth=4 ft=perl6
