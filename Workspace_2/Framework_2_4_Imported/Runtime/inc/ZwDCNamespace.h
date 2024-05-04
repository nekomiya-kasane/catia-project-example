

#ifndef _ZWDCNAMESPACE_H_H
#define _ZWDCNAMESPACE_H_H

#define BEGIN_NAMESPACE(_X)		namespace _X{
#define END_NAMESPACE()			};
#define BEGIN_DC_NAMESPACE()	namespace ZWDC{
#define END_DC_NAMESPACE()		};

#define USING_DC_NAMESPACE()	using namespace ZWDC;
#define DC_NAMESPACE_PREFIX		ZWDC::

#endif //_ZWDCNAMESPACE_H_H


