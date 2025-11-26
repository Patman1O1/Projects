
#ifndef LAMBDA_EXPORT_H
#define LAMBDA_EXPORT_H

#ifdef LAMBDA_STATIC_DEFINE
#  define LAMBDA_EXPORT
#  define LAMBDA_NO_EXPORT
#else
#  ifndef LAMBDA_EXPORT
#    ifdef lambda_EXPORTS
        /* We are building this library */
#      define LAMBDA_EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define LAMBDA_EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef LAMBDA_NO_EXPORT
#    define LAMBDA_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef LAMBDA_DEPRECATED
#  define LAMBDA_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef LAMBDA_DEPRECATED_EXPORT
#  define LAMBDA_DEPRECATED_EXPORT LAMBDA_EXPORT LAMBDA_DEPRECATED
#endif

#ifndef LAMBDA_DEPRECATED_NO_EXPORT
#  define LAMBDA_DEPRECATED_NO_EXPORT LAMBDA_NO_EXPORT LAMBDA_DEPRECATED
#endif

/* NOLINTNEXTLINE(readability-avoid-unconditional-preprocessor-if) */
#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef LAMBDA_NO_DEPRECATED
#    define LAMBDA_NO_DEPRECATED
#  endif
#endif

#endif /* LAMBDA_EXPORT_H */
