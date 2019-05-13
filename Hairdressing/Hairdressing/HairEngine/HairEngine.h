//
//  HairEngine.h
//  Demo
//
//  Created by charles wong on 13-7-27.
//  Copyright (c) 2013年 charles wong. All rights reserved.
//

#ifndef HairEngine_H
#define HairEngine_H

//#define UsingASMModule
//#define ExportData

#include <opencv2/opencv.hpp>
#include <stdlib.h>

class PaintSelection;
#ifdef UsingASMModule
class HeadDetector;
#endif
class RegTest;
class HeadGenerator;
class FeatureAdjuster;
class TexGenerator;
class IRenderer;

union HEPointF
{
    HEPointF(){};
    HEPointF(float theX, float theY)
    {
        x = theX;
        y = theY;
    }
    float data[2];
    struct {float x,y;};
};

struct HEContour
{
    HEContour()
    {
        contourNum = 0;
        totalPointsNum = 0;
        contourPointNumArray  =NULL;
        contourPoints = NULL;
    }
    
    int contourNum;
    int * contourPointNumArray;
    int totalPointsNum;
    HEPointF * contourPoints;
};

class HairEngine
{
public:
    HairEngine();
    ~HairEngine();
    
    bool                initEngine              (const char * dataDir, bool useRegressor);
    bool                closeEngine             ();
    
    bool                setImage                (const unsigned char * bitmapData, int width, int height, const char * workDir);
    //unsigned char *     addStroke             (int type, int size, int * pointArray);
    HEContour *         addStroke               (int type, int size, int * pointArray);
    bool                clearStroke             ();
    bool                finishStroke            (float pmaxDiff);
    
    bool                initViewer              (int width, int height);
    bool                closeViewer             ();
    bool                resizeViewer            (int width, int height);
    bool                setHairDir              (const char * hairDir);
    bool                setTransform            (float & xDegree, float & yDegree, float  & scale);
    bool                resetTransform          ();
    bool                adjustHairPosition      (float disX, float disY, float disZ, float scale);
    bool                resetHairPosition       ();
    bool                enableShadow            (bool enable);
    bool                enableExpression        (bool enable);
    bool                enableRotate            (bool enable);
    bool                render                  ();
    unsigned char *     takeScreenShot          (int & width, int & height);
    unsigned char *     generateThumbImage      (const char * hairDir, int & width, int & height);
    bool                saveInteractionState    ();
    bool                reloadInteractionState  ();
    unsigned char *     generateFrameForGif     (int & width, int & height);
    
    bool                finishStrokeStep1       (); //检测特征点，生成头部geometry
    bool                finishStrokeStep2       (float pmaxDiff); //生成texture
    cv::Mat &           getFeatureMat           ();
    bool                evaluateHairTrans       ();
    cv::Mat             getAdjustedFeatureMat    ();
    void                setFeatureAdjustSearchDistance(float distance);
    
private:
    IplImage *          convertImageData2IplImage(const unsigned char * srcBitmap, int srcWidth, int srcHeight);
    void                generateSelectionImage();
    void                evaluateFaceImageFromInputImage();
    void                evaluatePartialFaceImageFromInputImage();
    
    PaintSelection *    _PaintSelection;
#ifdef UsingASMModule
    HeadDetector *      _HeadDetector;
#endif
    RegTest      *      _RegTest;
    HeadGenerator *     _HeadGenerator;
    FeatureAdjuster *   _FeatureAdjuster;
    TexGenerator *      _TexGenerator;
    IRenderer *          _Renderer;
    
    char                _DataDir[500];
    char                _WorkDir[500];
    unsigned char *     _InputBitmapData;
    int                 _InputBitmapWidth;
    int                 _InputBitmapHeight;
    unsigned char *     _SelectionImageData;
    unsigned char *     _InputFaceImageData;
    unsigned char *     _inputPartialFaceImageData; //除去眼睛 鼻子 眉毛 嘴唇的面部区域
    
    bool                _NeedGenerateHeadModel;
    bool                _NeedGenerateTexture;
    unsigned int        _VaildHairStrokeNum;
    
    HEContour           _HEContour;
    
    bool                _UseRegressor;
};

#endif /* defined(__Demo__HairEngine__) */
