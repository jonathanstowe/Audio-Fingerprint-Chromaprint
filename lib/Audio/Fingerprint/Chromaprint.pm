
use v6.c;
use NativeCall;

constant LIB = [ 'chromaprint', v0 ];

## Enumerations

# == /usr/include/chromaprint.h ==

enum ChromaprintAlgorithm is export (
   CHROMAPRINT_ALGORITHM_TEST1 => 0,
   CHROMAPRINT_ALGORITHM_TEST2 => 1,
   CHROMAPRINT_ALGORITHM_TEST3 => 2,
   CHROMAPRINT_ALGORITHM_TEST4 => 3
);
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
sub chromaprint_get_version(
                            ) is native(LIB) returns Str is export { * }

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
sub chromaprint_new(int32 $algorithm # int
                    ) is native(LIB) returns Pointer[Pointer] is export { * }

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
sub chromaprint_free(Pointer[Pointer] $ctx # Typedef<ChromaprintContext>->|void*|*
                     ) is native(LIB)  is export { * }

#-From /usr/include/chromaprint.h:98
#/**
# * Return the fingerprint algorithm this context is configured to use.
# */
#CHROMAPRINT_API int chromaprint_get_algorithm(ChromaprintContext *ctx);
sub chromaprint_get_algorithm(Pointer[Pointer] $ctx # Typedef<ChromaprintContext>->|void*|*
                              ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_set_option(Pointer[Pointer]              $ctx # Typedef<ChromaprintContext>->|void*|*
                          ,Str                           $name # const char*
                          ,int32                         $value # int
                           ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_start(Pointer[Pointer]              $ctx # Typedef<ChromaprintContext>->|void*|*
                     ,int32                         $sample_rate # int
                     ,int32                         $num_channels # int
                      ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_feed(Pointer[Pointer]              $ctx # Typedef<ChromaprintContext>->|void*|*
                    ,Pointer                       $data # void*
                    ,int32                         $size # int
                     ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_finish(Pointer[Pointer] $ctx # Typedef<ChromaprintContext>->|void*|*
                       ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_get_fingerprint(Pointer[Pointer]              $ctx # Typedef<ChromaprintContext>->|void*|*
                               ,Pointer[Str]                  $fingerprint # char**
                                ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_get_raw_fingerprint(Pointer[Pointer]              $ctx # Typedef<ChromaprintContext>->|void*|*
                                   ,Pointer[Pointer]              $fingerprint # void**
                                   ,Pointer[int32]                $size # int*
                                    ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_encode_fingerprint(Pointer                       $fp # const void*
                                  ,int32                         $size # int
                                  ,int32                         $algorithm # int
                                  ,Pointer[Pointer]              $encoded_fp # void**
                                  ,Pointer[int32]                $encoded_size # int*
                                  ,int32                         $base64 # int
                                   ) is native(LIB) returns int32 is export { * }

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
sub chromaprint_decode_fingerprint(Pointer                       $encoded_fp # const void*
                                  ,int32                         $encoded_size # int
                                  ,Pointer[Pointer]              $fp # void**
                                  ,Pointer[int32]                $size # int*
                                  ,Pointer[int32]                $algorithm # int*
                                  ,int32                         $base64 # int
                                   ) is native(LIB) returns int32 is export { * }

#-From /usr/include/chromaprint.h:244
#/**
# * Free memory allocated by any function from the Chromaprint API.
# *
# * Parameters:
# *  - ptr: Pointer to be deallocated
# */
#CHROMAPRINT_API void chromaprint_dealloc(void *ptr);
sub chromaprint_dealloc(Pointer $ptr # void*
                        ) is native(LIB)  is export { * }

## Externs

