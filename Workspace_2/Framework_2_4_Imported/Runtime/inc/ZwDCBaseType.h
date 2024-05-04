
#ifndef _ZWDCBASETYPE_H_H
#define _ZWDCBASETYPE_H_H

#include "ZwDCBaseType.h"
#include "ZwDCPlatform.h"
#include "ZwDCNamespace.h"

#include <assert.h>
#include <limits>
#include <type_traits>

BEGIN_DC_NAMESPACE()

#define ZWDC_ENDIAN_BIG			1
#define ZWDC_ENDIAN_LITTLE		2

#ifdef ZWDC_CPU_BIGRADIAN
#define ZWDC_RADIAN ZWDC_ENDIAN_BIG
#else 
#define ZWDC_RADIAN ZWDC_ENDIAN_LITTLE
#endif

#if ZWDC_COMPILER == ZWDC_COMPILER_MSVC
typedef signed __int8		int8_t;
typedef signed __int16		int16_t;
typedef signed __int32		int32_t;
typedef signed __int64		int64_t;
typedef unsigned __int8		uint8_t;
typedef unsigned __int16	uint16_t;
typedef unsigned __int32	uint32_t;
typedef unsigned __int64	uint64_t;
#define ALIGN(bytes, type) __declspec(align(bytes)) type
#else
#include <stdint.h>
#define ALIGN(bytes, type) type __attribute__((aligned(bytes)))
#endif

#ifndef CONST_PI
#define CONST_PI  (3.141592653589)
#endif
#ifndef PI
#define PI 3.1415926535897932
#endif

#if (__cplusplus >= 201703L) || (defined(_MSVC_LANG) && (_MSVC_LANG >= 201703L)) // C++17 Features
#ifndef ZWDC_HAS_CXX17
#define ZWDC_HAS_CXX17
#endif // c++17
#if (__cplusplus >= 201704L) || (defined(_MSVC_LANG) && (_MSVC_LANG >= 201704L) && (_MSC_VER >= 1903)) // C++20 Partial Features
#ifndef ZWDC_HAS_CXX20
#define ZWDC_HAS_CXX20
#endif // c++20 partly
#endif // c++20
#endif // c++17

#ifdef ZWDC_HAS_CXX17
#define ZWDC_NODISCARD [[nodiscard]]
#define ZWDC_FALLTHROUGH [[fallthrough]]
#else
#define ZWDC_NODISCARD 
#define ZWDC_FALLTHROUGH 
#endif

#define ZWDC_SEALED	  sealed
#define ZWDC_INLINE   inline
#define ZWDC_NOEXCEPT noexcept

#if defined(_WIN32) || defined(_WIN64)
#ifdef _WIN64
#undef ZWDC_32BIT
#define ZWDC_64BIT 
#else
#undef ZWDC_64BIT
#define ZWDC_32BIT
#endif // WIN64
#elif defined(__GNUC__)
#if defined(__x86_64__) || defined(__ppc64__)
#undef ZWDC_32BIT
#define ZWDC_64BIT 
#else
#undef ZWDC_64BIT
#define ZWDC_32BIT
#endif // LINUX64
#endif // WIN

typedef char			ZDCHAR;
typedef wchar_t			ZDWCHAR;
typedef unsigned char	ZDUCHAR;
#if ZWDC_BUILD_CHARACTERS == ZWDC_CHARACTERS_MBCS
typedef ZDCHAR			ZDTCHAR;
#define ZD__T(X)		X
#elif ZWDC_BUILD_CHARACTERS == ZWDC_CHARACTERS_UNICODE
typedef ZDWCHAR			ZDTCHAR;
#define ZD__T(X)		L ## X
#else
typedef ZDCHAR			ZDTCHAR;
#define ZD__T(X)        X
#endif
#define ZD_T(X)			ZD__T(X)

#ifndef ZW_T
#define ZW__T(X)		L##X
#define ZW_T(X)			ZW__T(X)
#endif

#ifndef ZD_UNICODE
#   define ZD_UNICODE 1
#else
#   if ZD_UNICODE != 1
#       undef ZD_UNICODE
#       define ZD_UNICODE 1
#   endif
#endif

#if defined(__cplusplus) && defined(_MSC_VER) && !defined(_NATIVE_WCHAR_T_DEFINED)  
#error Please use native wchar_t type (/Zc:wchar_t)
#endif

#ifndef ZCRX_T
#define _ZCRX_T(x)      L ## x
#define ZCRX_T(x)      _ZCRX_T(x)
#endif


enum PEEntityType : size_t {
    PEENTITY_NONE            /**/ = 0x000000, /* AcDbCamera, AcDbGeoPositionMarker */
    PEENTITY_EXTRA           /**/ = 0x800000, /* AcDb */
    PEENTITY_CURVE           /**/ = 0x000001, /* AcDbCurve */
    PEENTITY_MPOLYGON        /**/ = 0x000002, /* AcDbCurve */
    PEENTITY_SOLID           /**/ = 0x000004, /* AcDbSolid */
    PEENTITY_3DSOLID         /**/ = 0x000008, /* AcDb3DSolid */
    PEENTITY_POLYFACEMESH    /**/ = 0x000010, /* AcDbPolyFaceMesh */
    PEENTITY_POLYGONMESH     /**/ = 0x000020, /* AcDbPolygonMesh */
    PEENTITY_SURFACE         /**/ = 0x000040, /* AcDbSurface */
    PEENTITY_MESH            /**/ = 0x000080, /* AcDbSubDMesh */
    PEENTITY_DIMENSION       /**/ = 0x000100, /* AcDbDimension */
    PEENTITY_BLOCK           /**/ = 0x000200, /* AcDbBlockReference */
    PEENTITY_TEXT            /**/ = 0x000400, /* AcDbText, AcDbMText */
    PEENTITY_LEADER          /**/ = 0x000800, /* AcDbLeader, AcDbMLeader */
    PEENTITY_SHAPE           /**/ = 0x001000, /* AcDbShape */
    PEENTITY_POINT           /**/ = 0x002000, /* AcDbPoint */
    PEENTITY_RAY             /**/ = 0x004000, /* AcDbRay */
    PEENTITY_XLINE           /**/ = 0x008000, /* AcDbXline */
    PEENTITY_HATCH           /**/ = 0x010000, /* AcDbHatch */
    PEENTITY_FCF             /**/ = 0x020000, /* AcDbFcf */
    PEENTITY_MLINE           /**/ = 0x040000, /* AcDbMline */

    PEENTITY_SIMPLE_WIRE     /**/ = PEENTITY_CURVE | PEENTITY_MPOLYGON | PEENTITY_POINT | PEENTITY_RAY | PEENTITY_XLINE | PEENTITY_HATCH,
    PEENTITY_SIMPLE_NON_WIRE /**/ = PEENTITY_SOLID | PEENTITY_POLYFACEMESH | PEENTITY_POLYGONMESH | PEENTITY_SURFACE | PEENTITY_MESH
                                  | PEENTITY_FCF | PEENTITY_LEADER | PEENTITY_TEXT | PEENTITY_SHAPE | PEENTITY_EXTRA,
    PEENTITY_SIMPLE          /**/ = PEENTITY_SIMPLE_WIRE | PEENTITY_SIMPLE_NON_WIRE,
    PEENTITY_COMPLEX         /**/ = PEENTITY_3DSOLID | PEENTITY_MLINE,
    PEENTITY_RECURSIVE       /**/ = PEENTITY_DIMENSION | PEENTITY_BLOCK,
    PEENTITY_INFINITE        /**/ = PEENTITY_XLINE | PEENTITY_RAY,
    
    PEENTITY_BREPABLE        /**/ = PEENTITY_CURVE | PEENTITY_MPOLYGON | PEENTITY_POINT | PEENTITY_RAY | PEENTITY_XLINE | PEENTITY_FCF
                                  | PEENTITY_SOLID | PEENTITY_POLYFACEMESH | PEENTITY_POLYGONMESH | PEENTITY_SURFACE | PEENTITY_3DSOLID,
    PEENTITY_FULL            /**/ = PEENTITY_SIMPLE | PEENTITY_COMPLEX | PEENTITY_RECURSIVE,
};

#define CatagorizedRepr std::map<const UpStyle, std::vector<PRC::PRCRepresentationItem*>>

END_DC_NAMESPACE()




#endif //_ZWDCBASETYPE_H_H