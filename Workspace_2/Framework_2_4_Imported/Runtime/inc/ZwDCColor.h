

#ifndef _ZWDCCOLOR_H_H
#define _ZWDCCOLOR_H_H

#include "ZwDCExport.h"
#include "ZwDCNamespace.h"
BEGIN_DC_NAMESPACE()

class ZCDC_EXPORT ZcDcColor
{
public:
	ZcDcColor();
	ZcDcColor(unsigned char nRed, unsigned char nGreen, unsigned char nBlue, unsigned char nAlpha);
	ZcDcColor(const ZcDcColor& src) = default;
	bool operator == (const ZcDcColor& src)const
	{
		return (m_red == src.m_red) && (m_blue == src.m_blue) && (m_green == src.m_green) && (m_alpha == src.m_alpha);
	}
	bool operator != (const ZcDcColor& src)
	{
		return !((m_red == src.m_red) && (m_blue == src.m_blue) && (m_green == src.m_green) && (m_alpha == src.m_alpha));
	}
	unsigned char red()const { return m_red; }
	unsigned char green()const { return m_green; }
	unsigned char blue()const { return m_blue; }
	unsigned char alpha()const { return m_alpha; }
	void setRGBA(unsigned char nRed, unsigned char nGreen, unsigned char nBlue, unsigned char nAlpha = 0xff);
	void setRGBA(double nRedPercent, double nGreenPercent, double nBluePercent, double nAlphaPercent = 1.);
    ZcDcColor reverse() { return ZcDcColor( ~m_red, ~m_green, ~m_blue, m_alpha ); }
protected:
	unsigned char m_red;
	unsigned char m_green;
	unsigned char m_blue;
	unsigned char m_alpha;
};
END_DC_NAMESPACE()

#endif//_ZWDCCOLOR_H_H