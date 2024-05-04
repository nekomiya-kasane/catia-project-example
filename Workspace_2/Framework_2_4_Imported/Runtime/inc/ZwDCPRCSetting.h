

#ifndef _ZWDCPRCSETTING_H_H
#define _ZWDCPRCSETTING_H_H

#include "ZwDCBaseType.h"
#include "ZwDCColor.h"

#include <map>

BEGIN_DC_NAMESPACE()

#if 0
enum TriangulationLevel
{
	// 弦高比、线框弦角度、最大弦高度、最小三角行角度依次为
	eExtremelyLow,	// 50	, 40d, 1, 20d  
	eLow,			// 600	, 40d, 1, 20d
	eMedium,		// 2000	, 40d, 1, 20d
	eHigh,			// 5000	, 30d, 1, 20d
	eExtremelyHigh, // 10000, 20d, 1, 20d
	eCtrlAccuracy,	// 2000	, 40d, 1, 20d 可控的精确度
	eUserDefined,	// 2000	, 40d, 1, 20d
};

struct TriangulationSetting
{
    size_t m_nChordHighRatio = 2000;
	double m_rWireChordAngle = (2 / 9) * PI;   // 线框弦角度
	double m_rMaxChordHeight = 1.0;   // 最大弦高度
	double m_rMinTriangleAngle = (1 / 9) * PI; // 最小三角角度 
};
#endif

struct PRCOptimizeSetting
{
    bool                    compressedBrep = false;
    double                  generalBrepCompressionTolerence = 1e-3;
    bool                    compressedWire = false;
    double                  generalWireCompressionTolerence = 1e-3;
    bool                    compressedTess = false;
    double                  generalTessCompressionTolerence = 1e-3;
    bool                    modelLcs = false;
    bool                    solidWireFrameSupport = true;
    bool                    meshWireFrameSupport = true;
    bool                    brepWithTraitsSupport = true;
    // bool                    shapeLineTypeSupport = true; // hard to support

    double nurbsControlPointsTolerence = generalBrepCompressionTolerence;
    double nurbsKnotsTolerence = generalBrepCompressionTolerence;
    double generalConversionTolerence = generalBrepCompressionTolerence * 1e-3;

    size_t                  useBrep = PEENTITY_BREPABLE;
};

class PRCGeneralSetting
{
public:
    enum DefaultViews {
        None                    = 1 << 12,
        PerspectiveLeftView     = 1,
        OrthographicLeftView    = 1 << 1,
        PerspectiveRightView    = 1 << 2,
        OrthographicRightView   = 1 << 3,
        PerspectiveBackView     = 1 << 4,
        OrthographicBackView    = 1 << 5,
        PerspectiveFrontView    = 1 << 6,
        OrthographicFrontView   = 1 << 7,
        PerspectiveTopView      = 1 << 8,
        OrthographicTopView     = 1 << 9,
        PerspectiveBottomView   = 1 << 10,
        OrthographicBottomView  = 1 << 11
    };
#if 0
    PRCGeneralSetting()
        : m_bPerspectiveDefaultView(false)
    {
    }
    void setUseDefaultOrthogonalView(bool val) { m_bPerspectiveDefaultView = !val; }
    void setUseDefaultPerspectiveView(bool val) { m_bPerspectiveDefaultView = val; }
    bool isDefaultOrthogonalView() const { return !m_bPerspectiveDefaultView; }
    bool isDefaultPerspectiveMode() const { return m_bPerspectiveDefaultView; }
#endif
    void setAddDefaultViews(size_t val) { m_bAddDefaultViews = (val & DefaultViews::None) ? 0 : (val & 0x7FF); }
    size_t addDefaultViews() const { return m_bAddDefaultViews; }
public:
    ZcDcColor backgroundColor = { 0x0, 0x0, 0x0, 0xff }; //black
    //ZcDcColor foregroundColor = { 0xFF, 0xFF, 0xFF, 0xff }; //black
protected:
	bool m_bPerspectiveDefaultView;
    size_t m_bAddDefaultViews;
};

struct PageLayout {
public:
#if 0
    enum class PresetLayout {
        Custom,
        A4Paper
    };
#endif

    PageLayout() :
        m_left(0), m_right(0), m_top(0), m_bottom(0),
        m_paperWidth(595), m_paperHeight(842),
#if 0
        m_layout(PresetLayout::A4Paper), // A4
#endif
        m_portrait(true) {}

    unsigned bleedLeft() const { return m_left; }
    unsigned bleedRight() const { return m_right; }
    unsigned bleedTop() const { return m_top; }
    unsigned bleedBottom() const { return m_bottom; }
    unsigned paperWidth() const { return m_paperWidth; }
    unsigned paperHeight() const { return m_paperHeight; }
    
    void setBleed(unsigned left, unsigned right, unsigned top, unsigned bottom) {
        m_left = left; m_right = right; m_top = top; m_bottom = bottom;
    }
#if 0
    void set(PresetLayout layout) { 
        m_layout = layout; 
        std::tie(m_paperWidth, m_paperHeight) = presetLayouts->at(layout); 
    }
#endif
    void set(unsigned w, unsigned h) { m_paperWidth = w; m_paperHeight = h; }
protected:
    // layouts
#if 0
    static std::map<PresetLayout, std::pair<double, double>>* presetLayouts;
    PresetLayout m_layout;
#endif
    unsigned m_paperWidth;
    unsigned m_paperHeight;

    // bleeds
    unsigned m_left;
    unsigned m_right;
    unsigned m_top;
    unsigned m_bottom;

    // orientation
    bool m_portrait;
};

class PRCDocumentSetting
{
public:
    PRCDocumentSetting() : m_basePDFPath(L"temp.pdf"), m_password() {}

    PageLayout paperLayout() const { return m_layout; }
    std::wstring PRCPath() const { return m_prcPath; }
    std::wstring outputFilePath() const { return m_outputPDFPath; }

    void setPaperLayout(PageLayout layout) { m_layout = layout; }
    void setPRCPath(std::wstring path) { m_prcPath = path; }
    void setOutputFilePath(std::wstring path) { m_outputPDFPath = path; }
protected:
    friend struct PRCSettings;
    PageLayout m_layout;
    std::wstring m_prcPath;
    std::wstring m_basePDFPath;
    std::wstring m_outputPDFPath;
    std::wstring m_password;

    std::pair<double, double> position;
};

struct PRCImportSetting
{
    bool useTransparency = false;
	bool useExtendedGeometries = true; // PRCCurve/PRCSurf etc.
    bool drawInfinityEntitiesAtLast = true;
    bool useInfinityDouble = false;
    size_t importedContent = ZWDC::PEENTITY_FULL & ~(ZWDC::PEENTITY_RAY | ZWDC::PEENTITY_XLINE);
};

struct PRCSettings
{
    static PRCSettings  kDefault;

    void normalize();
	PRCGeneralSetting	general;
	PRCDocumentSetting	document;
	PRCOptimizeSetting	optimize;
	PRCImportSetting	import;
};



END_DC_NAMESPACE()

#endif //_ZWDCPRCSETTING_H_H
