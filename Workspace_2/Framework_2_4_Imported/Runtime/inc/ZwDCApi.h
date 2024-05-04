

#ifndef _ZCDCAPI_H_H
#define _ZCDCAPI_H_H

#include "ZwDCExport.h"
#include "ZwDCNamespace.h"
#include "ZwDCBaseType.h"

#include "ZwDCEmbedderBase.h"

class ZcDbExtents;

BEGIN_DC_NAMESPACE()

struct PRCSettings;

enum class ErrorStatus {
    eOk,
    eNoZcDbHostApplication,
    eFailedToReadDwgFile,
    eFailedToArchivePRCFile,
    eFailedToSaveFile,
    eFailedToGeneratePRCFileName,
    eFileAccessErrWhileEmbedding,
    eFailedToWritePDFFile,
    ePRCFileVerifyingFailed,
    eUnknown
};

ZCDC_EXPORT ZWDC::ErrorStatus zcdcDwgToPRC(const ZDTCHAR* pszPRCFileName, const ZDTCHAR* pszInputFileName, PRCSettings* setting, ZcDbExtents* pExt = nullptr);
ZCDC_EXPORT ZWDC::ErrorStatus zcdcDwgToPDF(const ZDTCHAR* pszPDFFileName, const ZDTCHAR* pszInputFileName, PRCSettings* setting, PRCEmbedder* embedder = nullptr /* leave it nullptr for default embedder */);
ZCDC_EXPORT ZWDC::ErrorStatus zcdcVerifyPRC(const ZDTCHAR* pszPRCFileName);

ZCDC_EXPORT bool zcdcInitDC();
ZCDC_EXPORT bool zcdcUnInitDC();

END_DC_NAMESPACE()


#endif //_ZCDCAPI_H_H