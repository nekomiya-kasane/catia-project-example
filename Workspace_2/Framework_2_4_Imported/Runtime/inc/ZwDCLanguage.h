
#ifndef _ZWDCLANGUAGE_H_H
#define _ZWDCLANGUAGE_H_H

#include "ZwDCExport.h"
#include "zwdcbasetype.h"


class ZCDC_TOOLKIT_EXPORT ZwDCLanguage
{
public:
	enum 
	{
		unknown = -1,
		cs_CZ = 0,
		de_DE,
		en_US,
		es_ES,
		fr_FR,
		hu_HU,
		it_IT,
		ja_JP,
		ko_KR,
		pl_PL,
		pt_BR,
		ru_RU,
		tr_TR,
		zh_CN,
		zh_TW,
		lcount
	};
	ZCDC_STATIC_EXPORT static bool	isValidShortName(const DC_NAMESPACE_PREFIX ZDTCHAR* pShortName);
	ZCDC_STATIC_EXPORT static int	shortNameToLangId(const DC_NAMESPACE_PREFIX ZDTCHAR* pShortName);
	ZCDC_STATIC_EXPORT static const DC_NAMESPACE_PREFIX ZDTCHAR* langIdToShortName(int nId);
	ZCDC_STATIC_EXPORT static int	languageLCID(int nLanguage);
};



#endif //_ZWDCLANGUAGE_H_H