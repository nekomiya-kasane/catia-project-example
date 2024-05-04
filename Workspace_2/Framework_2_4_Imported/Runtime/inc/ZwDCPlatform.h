
#ifndef _ZWDCPLATFORM_H_H
#define _ZWDCPLATFORM_H_H

#define	ZWDC_COMPILER_MSVC		1
#define	ZWDC_COMPILER_GNUC		2
#define	ZWDC_COMPILER_BORL		3
#define	ZWDC_COMPILER_WINSCW	4
#define	ZWDC_COMPILER_GCCE		5


#define ZWDC_BUILD_DEBUG		1
#define ZWDC_BUILD_RELEASE		2

#define ZWDC_CHARACTERS_UNICODE 1
#define ZWDC_CHARACTERS_MBCS	2

#if		defined( _MSC_VER )
#		define ZWDC_COMPILER				ZWDC_COMPILER_MSVC
#		define ZWDC_COMPILER_VER			_MSC_VER
#		define ZWDC_COMPILER_MSVC_14_0		1900
#		define ZWDC_COMPILER_MSVC_12_0		1800
#		define ZWDC_COMPILER_MSVC_11_0		1700
#		define ZWDC_COMPILER_MSVC_10_0		1600
#		define ZWDC_COMPILER_MSVC_9_0		1500
#		define ZWDC_COMPILER_MSVC_8_0		1400
#		define ZWDC_COMPILER_MSVC_7_1		1310
#		define ZWDC_COMPILER_MSVC_7_0		1300
#		define ZWDC_COMPILER_MSVC_6_0		1200
#		define ZWDC_COMPILER_MSVC_5_0		1100
#elif	defined( __GNUC__ )
#		define ZWDC_COMPILER				ZWDC_COMPILER_GNUC
#		define ZWDC_COMPILER_VER			(((__GNUC__)*100) + (__GNUC_MINOR__*10) + __GNUC_PATCHLEVEL__)
#elif	defined( __BORLANDC__ )
#		define ZWDC_COMPILER				ZWDC_COMPILER_BORL
#		define ZWDC_COMPILER_VER			__BCPLUSPLUS__
#		define __FUNCTION__					__FUNC__ 
#elif	defined( __WINSCW__ )
#		define ZWDC_COMPILER				ZWDC_COMPILER_WINSCW
#		define ZWDC_COMPILER_VER			_MSC_VER
#elif	defined( __GCCE__ )
#		define ZWDC_COMPILER				ZWDC_COMPILER_GCCE
#		define ZWDC_COMPILER_VER			_MSC_VER

#else 
#error "Unknown compiler. Abort! Abort!\n"
#endif

#if ZWDC_COMPILER != ZWDC_COMPILER_MSVC
#ifndef _UNICODE
#define _UNICODE
#endif
#endif

#ifdef _UNICODE
#ifndef ZWDC_DEF_UNCODE
#define ZWDC_DEF_UNCODE
#define ZWDC_CRT_WIDE_(s) L ## s
#define ZWDC_CRT_WIDE(s) ZWDC_CRT_WIDE_(s)
#endif
#else
#define ZWDC_CRT_WIDE(s) s
#endif

#if ZWDC_COMPILER == ZWDC_COMPILER_MSVC
#   if defined( _DEBUG ) || defined( DEBUG )
#		define ZWDC_BUILD_MODE ZWDC_BUILD_DEBUG
#   else
#		define ZWDC_BUILD_MODE ZWDC_BUILD_RELEASE
#	endif
#	if defined( _UNICODE ) || defined( _UNICODE )
#		define ZWDC_BUILD_CHARACTERS ZWDC_CHARACTERS_UNICODE
#	else 
#		define ZWDC_BUILD_CHARACTERS ZWDC_CHARACTERS_MBCS		
#	endif
#elif ZWDC_COMPILER == ZWDC_COMPILER_WINSCW

#elif ZWDC_COMPILER == ZWDC_COMPILER_BORL

#elif ZWDC_COMPILER == ZWDC_COMPILER_GCCE

#elif ZWDC_COMPILER == ZWDC_COMPILER_GNUC
#   if defined( _DEBUG ) || defined( DEBUG )
#		define ZWDC_BUILD_MODE ZWDC_BUILD_DEBUG
#   else
#		define ZWDC_BUILD_MODE ZWDC_BUILD_RELEASE
#	endif
#	if defined( _UNICODE ) || defined( _UNICODE )
#		define ZWDC_BUILD_CHARACTERS ZWDC_CHARACTERS_UNICODE
#	else 
#		define ZWDC_BUILD_CHARACTERS ZWDC_CHARACTERS_MBCS		
#	endif
#else 
#error "Unsupported compiler!!!\n"
#endif

#if ZWDC_COMPILER == ZWDC_COMPILER_MSVC

#	define ZWDC_ABSTRACT		__declspec(novtable)
#	define ZWDC_DEPRECATED	__declspec(deprecated)

#	if defined ZWDC_MAKE_STATIC_LIB
#		define ZWDC_EXPORT_DEF
#		define ZWDC_C_EXPORT_DEF
#		define ZWDC_IMPORT_DEF
#	else
#		if defined __cplusplus
#			define ZWDC_C_EXPORT_DEF	extern "C" __declspec(dllexport)
#		else
#			define ZWDC_C_EXPORT_DEF	__declspec(dllexport)
#		endif
#		define ZWDC_EXPORT_DEF		__declspec(dllexport)
#		define ZWDC_IMPORT_DEF		__declspec(dllimport)
#	endif

#	define ZWDC_REGISTER			register


#   define ZWDC_THISCALL			__thiscall
#	define ZWDC_STDCALL				__stdcall
#	define ZWDC_CDECL				__cdecl
#	define ZWDC_FASTCALL			__fastcall
#	define ZWDC_PASCAL				__pascal
#	define ZWDC_CALLBACK			__stdcall

#else

#	define ZWDC_ABSTRACT
#	define ZWDC_DEPRECATED
#	define ZWDC_EXPORT_DEF				__attribute__((visibility("default")))
#	define ZWDC_IMPORT_DEF				__attribute__((visibility("default")))
#	define ZWDC_REGISTER

#   define ZWDC_THISCALL			__attribute__((thiscall))
#	define ZWDC_STDCALL				__attribute__((stdcall))
#	define ZWDC_CDECL				__attribute__((cdecl))
#	define ZWDC_FASTCALL			__attribute__((fastcall))
#	define ZWDC_PASCAL				__attribute__((pascal))
#	define ZWDC_CALLBACK			__attribute__((stdcall))
#endif

#if ZWDC_COMPILER == ZWDC_COMPILER_MSVC && ZWDC_COMPILER_VER >= ZWDC_COMPILER_MSVC_6_0
#define ZWDC_FORCEINLINE __forceinline
#else 
#define ZWDC_FORCEINLINE inline
#endif

#define ZWDC_OVERRIDE	override

#ifdef ZWDC_INTERNAL
#define ZWDC_EXPORT ZWDC_EXPORT_DEF
#define ZWDC_STATIC_EXPORT		
#define ZWDC_TOOLKIT_EXPORT		ZWDC_EXPORT_DEF//class with static data memeber export
#else
#define ZWDC_EXPORT ZWDC_IMPORT_DEF
#define ZWDC_STATIC_EXPORT		ZWDC_IMPORT_DEF
#define ZWDC_TOOLKIT_EXPORT		
#endif 

#if ZWDC_BUILD_MODE == ZWDC_BUILD_DEBUG
ZWDC_EXPORT bool dcAssertFunc(const wchar_t* pDesc, const wchar_t* pFile, int nLineNum);
#	define ZWDC_FAIL()			dcAssertFunc(L"Invalid Execution.", nullptr/*##__FILE__*/, __LINE__)
#	define ZWDC_ASSERT(_EXPR)	((_EXPR) || !dcAssertFunc(L#_EXPR, ZWDC_CRT_WIDE(__FILE__), __LINE__))
#	define ZWDC_VERIFY(_EXPR)	ZWDC_ASSERT(_EXPR)
#   define ZWDC_FAIL_ONCE()		ZWDC_ASSERT(FALSE);
#else
#	define ZWDC_FAIL()
#	define ZWDC_ASSERT(_EXPR)
#	define ZWDC_VERIFY(_EXPR)		(_EXPR)
#   define ZWDC_FAIL_ONCE()
#endif

#endif //_ZWDCPLATFORM_H_H