#pragma once

#ifndef _ZWDC_EMBEDDER_BASE_H_
#define _ZWDC_EMBEDDER_BASE_H_

#include "ZwDCPlatform.h"
#include "ZwDCColor.h"

#include <string>
#include <vector>

// rewrite this to customize embedder

class PRCEmbedder {
public:
    struct CameraDesc {
        void setMatrix(double matrix[3][4]) {
            for (auto i = 0; i < 4; i++)
                for (auto j = 0; j < 3; j++)
                    _c2wMatrix[j][i] = matrix[j][i];
        }
        void setFocus(double focus) { _focus = focus; }
        void setCo(double co) { _co = co; }
        void setOs(double os) { _os = os; }
        void setName(const char* name) { _name = name; }
        void setBackground(double r, double g, double b) {
            _background[0] = r;
            _background[1] = g;
            _background[2] = b;
        }

        const auto matrix() const { return _c2wMatrix; }
        const auto background() const { return _background; }

        std::string _name;
        double _c2wMatrix[3][4];
        double _co, _os, _focus;
        double _background[3];
    };

    virtual ~PRCEmbedder() {};

    virtual bool write(std::wstring iPath, std::wstring iPRCPath) = 0;

    virtual void addCamera(
        const char* name,
        double extents[2][3] /* min, max */,
        double ptPosition[3],
        double ptTarget[3],
        double vecUp[3],
        double rFieldWidth,
        double rFieldHeight,
        bool bPerspective) = 0;

    virtual void setPageRect(unsigned left, unsigned top, unsigned right, unsigned bottom) = 0;
    virtual void setViewPort(unsigned left, unsigned top, unsigned right, unsigned bottom) = 0;

    virtual void setBackground(ZWDC::ZcDcColor iColor) = 0;

protected:
    std::vector<CameraDesc> _cameras;
};

#endif // _ZWDC_EMBEDDER_BASE_H_