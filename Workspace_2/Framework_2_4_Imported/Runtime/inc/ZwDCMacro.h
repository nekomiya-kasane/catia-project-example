
#ifndef _ZWDCMACRO_H_H
#define _ZWDCMACRO_H_H

#define ZDC_EOS	0

#if defined(_DEBUG) || defined(DEBUG)
#	ifndef ZW_DEBUG
#		define ZW_DEBUG
#	endif
#endif 

#define ZDC_VERIFY_EOK(_X)	(Zcad::eOk == (_X))

#define ZDCOLORREF			unsigned int
#define ZDRGB(r,g,b)		((ZDCOLORREF)(((unsigned char)(r)|((unsigned short)((unsigned char)(g))<<8))|(((unsigned int)(unsigned char)(b))<<16)))
#define ZDRGBA(r,g,b,a)		(((ZDCOLORREF)ZDRGB(r,g,b))|(((unsigned int)(unsigned char)(a))<<24))

#define ZDGETRED(rgb)		((unsigned char)(rgb))
#define ZDGETGREEN(rgb)		((unsigned char)(((unsigned short)(rgb)) >> 8))
#define ZDGETBLUE(rgb)		((unsigned char)((rgb)>>16))
#define ZDGETALPHA(rgba)	((unsigned char)((rgba)>>24))
#define ZDC_Min(X,Y) ((X) < (Y) ? (X) : (Y))
#define ZDC_Max(X,Y) ((X) > (Y) ? (X) : (Y))
#define ZDC_PI				3.14159265358979323846

#define ZERO_LAYER_INDEX    ((size_t)0)
#define INVALID_TESS_INDEX  ((size_t)-1)

#define ALLOW_EMPTY_TESS

#endif //_ZWDCMACRO_H_H