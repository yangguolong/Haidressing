#ifndef _IMAGEPROCESSOR_H_
#define _IMAGEPROCESSOR_H_

#ifdef __cplusplus
extern "C" {
#endif

/*
 * 使用色彩平衡功能实现皮肤美白的功能，相当于在色彩平衡只处理中间调，
 * 并且三个颜色调节参数都取相同的正值，且不勾选保持明度时的算法。
 *
 * src: 需要处理的人物图像数据部分在内存中的地址，只能处理24位真彩色。
 * dst: 保存处理结果的图像数据地址，必须和Src具有相同的大小和格式。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 * level: 美白的力度，建议取值范围[0,150]，值越大则美白力度越强。
 *
 * dst参数可以和src相同，这种情况下则是直接对原始图像的数据进行修改。
 */
void SkinWhiteningUseColorBalance(unsigned char* src, unsigned char* dst, int width, int height, int stride, int level);

/*
 * 使用指定曲线来美白，曲线来自于文章<A Two-Stage Contrast Enhancement Algorithm for Digital Images>
 * level相当于文章的中Beta,最小值为2，值越大，图像越亮（整体调亮）
 *
 * src: 需要处理的人物图像数据部分在内存中的地址，只能处理24位真彩色。
 * dst: 保存处理结果的图像数据地址，必须和Src具有相同的大小和格式。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 * level: 美白的力度，建议取值范围[2,10]，值越大则美白力度越强。
 * dst参数可以和src相同，这种情况下则是直接对原始图像的数据进行修改。
 */
void SkinWhiteningUseLogCurve(unsigned char* src, unsigned char* dst, int width, int height, int stride, int level);

/*
 * 简单的一键美白效果
 *
 * src: 需要处理的人物图像数据部分在内存中的地址，只能处理24位真彩色。
 * dst: 保存处理结果的图像数据地址，必须和Src具有相同的大小和格式。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 * dst参数可以和src相同，这种情况下则是直接对原始图像的数据进行修改。
 */
void SkinWhiteningFast(unsigned char* src, unsigned char* dst, int width, int height, int stride);

/*
 * 实现图像的磨皮效果,基于<Bi-Exponential Edge-Preserving Smoother>一文
 *
 * src: 需要处理的人物图像数据部分在内存中的地址，只能处理24位真彩色。
 * dst: 保存处理结果的图像数据地址，必须和Src具有相同的大小和格式。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 * acneRemovel: 磨皮的程度，建议取值范围5到15，越大皮肤越光滑，但过大会失真。
 */
void DermabrasionFilter(unsigned char* src, unsigned char* dst, int width, int height, int stride, int acneRemovel);


/*
 * 实现图像高斯模糊效果，O(1)复杂度
 * 参考论文：Recursive implementation of the Gaussian filter
 *
 * src: 源图像数据在内存的起始地址。
 * dst: 目标图像数据在内存的起始地址。
 * width: 源和目标图像的宽度。
 * height: 源和目标图像的高度。
 * radius: 方框模糊的半径，有效范围[0.1,1000]。
 *
 * 能处理8位灰度和24位图像。
 * src和dst可以相同，相同和不同速度上无区别。
 * 使用了多线程，可加快执行速度
 */
void GuassBlur(unsigned char* src, unsigned char* dst, int width, int height,int stride, float radius);

/*
 * 得到一幅人物图像中的皮肤区域的蒙版数据，这个数据即要考虑到皮肤部分的简单区别，
 * 也要考虑和非皮肤区域的分别出的自然过渡,还得注意非皮肤区域的适当处理 。
 *
 * src: 人物图像数据部分在内存中的地址，只能处理24位真彩色。
 * skin: 由用户负责分配和回收的内存，大小必须是width * height字节。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 *
 * 保留头发等细节这一步是关键的一步，但是这一步可以通过多种方式实现，下面只是我目前总结的一种实现方式。
 * 这种方式已经证明对于黑色头发有着较好的保护作用，但是对于某些图像的其他颜色的背景无效。
 */
void GetSkinArea(unsigned char* src, unsigned char* skin, int width, int height, int stride);

/*
 * 先水平后垂直方向的滤波。
 *
 * data: 需要滤波的数据。
 * width: 滤波数据的水平方向大小。
 * height: 滤波数据的垂直方向大小。
 * spatialContraDecay: 空域标准差。
 * photometricStandardDeviation: 值域的标准差。
 */
void BEEPSHorizontalVertical(float* data, int width, int height, float spatialContraDecay, float photometricStandardDeviation);

/*
 * 先垂直后水平方向的滤波，此过程和BEEPSHorizontalVertical基本类似，只是先进行垂直处理，再水平方向处理
 *
 * data: 需要滤波的数据。
 * width: 滤波数据的水平方向大小。
 * height: 滤波数据的垂直方向大小。
 * spatialContraDecay: 空域标准差。
 * photometricStandardDeviation: 值域的标准差。
 */
void BEEPSVerticalHorizontal(float* data, int width, int height, float spatialContraDecay, float photometricStandardDeviation);

/*
 * 基于Beep的边缘保留平滑滤波的实现，整理日期：2014.9.20
 * 参考论文： Bi-Exponential Edge-Preserving Smoother.
 *
 * src: 待处理的灰度图像数据在内存的起始地址。
 * dst: 目标图像数据在内存的起始地址。
 * width: 图像的宽度。
 * height: 图像的高度。
 * stride: 图像的扫描行大小。
 * spatialContraDecay: 空域标准差。
 * photometricStandardDeviation: 值域的标准差。
 *
 * 程序的执行时间和算法的参数无关。
 * src和dst可以相同，相同和不同时执行速度无区别。
 * 采用了多线程方式，在多核下可以明显加快速度。
 * 此算法本身高度并行，可利用GPU等大幅加速。
 */
void BiExponentialEPF(unsigned char* src, unsigned char* dst, int width, int height, int stride, float spatialContraDecay, float photometricStandardDeviation);

/*
 * 将两幅图像按照设定的Mask图进行Alpha混合,2014年9越21日整理。
 *
 * src: 混合的原图像数据在内存的起始地址。
 * dst: 混合的目标图像数据在内存的起始地址。
 * mask: 蒙版图像，必须是灰度图。
 * width: 原图及目标图像的宽度，。
 * height: 原图及目标图像的高度。
 * stride: 原图及目标图像的扫描行大小。
 * maskStride: mask图像的扫描行大小。
 *
 * 原图、目标图及mask的宽度、高度必须都相等，原图和目标图必须都是24位的，Mask图必须是8位的。
 */
void BlendImageWithMask(unsigned char* src, unsigned char* dst, unsigned char* mask, int width, int height, int stride, int maskStride);

/*
 * 实现类似photoshop的USM锐化效果，O(1)复杂度，最新整理时间 2014.9.21。
 *
 * src: 源图像数据在内存的起始地址。
 * dst: 目标图像数据在内存的起始地址。
 * width: 源和目标图像的宽度。
 * height: 源和目标图像的高度。
 * radius: 半径[1-250]，用来决定作边沿强调的像素点的宽度。
 * amount: 数量[1-500]，控制锐化效果的强度。
 * threshold: 阈值[0-255]，决定多大反差的相邻像素边界可以被锐化处理，而低于此反差值就不作锐化。
 *
 * 程序的执行时间和算法的参数无关。
 * src和dst可以相同，相同和不同时执行速度无区别。
 */
void UnsharpMask(unsigned char* src, unsigned char* dst, int width, int height, int stride, float radius, int amount, int threshold);



#ifdef __cplusplus
}
#endif
#endif
