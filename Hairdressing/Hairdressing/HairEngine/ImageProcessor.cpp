#include "ImageProcessor.h"

//#include "ImageUtils.h"
#include "math.h"
//#include "omp.h"
#include "stdlib.h"

//#include <android/log.h>

//#define LOG_TAG "ImageProcessor"
//#define LOGV(...) ((void)__android_log_print(ANDROID_LOG_VERBOSE, LOG_TAG, __VA_ARGS__))
//#define LOGD(...) ((void)__android_log_print(ANDROID_LOG_DEBUG,   LOG_TAG, __VA_ARGS__))
//#define LOGI(...) ((void)__android_log_print(ANDROID_LOG_INFO,    LOG_TAG, __VA_ARGS__))
//#define LOGW(...) ((void)__android_log_print(ANDROID_LOG_WARN,    LOG_TAG, __VA_ARGS__))
//#define LOGE(...) ((void)__android_log_print(ANDROID_LOG_ERROR,   LOG_TAG, __VA_ARGS__))
inline  char Clamp(int n)
{
    return ( char) ( (n | ((signed int)(255 - n) >> 31) ) & ~((signed int)n >> 31)) ;
}
void SkinWhiteningUseColorBalance(unsigned char* src, unsigned char* dst, int width, int height, int stride, int level)
{
	int X, Y, Alpha, InvertAlpha, Blue, Green, Red;
	unsigned char *Table = (unsigned char *)malloc(256);
	unsigned char *Skin = (unsigned char *)malloc(width * height);
	unsigned char *SrcP, *DestP, *SkinP;
	GetSkinArea(src, Skin, width, height, stride);

    for(Y = 0; Y < 256; Y++)
	{
        Table[Y] = Clamp(Y + (int)(level *  0.667 * (1 - pow((Y - 127.0) / 127.0, 2))));		//	满足summary中描述的色彩平衡算法经处理就是这样的一个查找表了，色彩平衡的完整代码可以从GIMP中获取。
	}
	for (Y = 0; Y < height; Y++)
	{
		SrcP = src + Y * stride;
		DestP = dst + Y * stride;
		SkinP = Skin + Y * width;
		for(X = 0; X < width; X++)
		{
			Alpha = SkinP[0]; InvertAlpha = 255 - Alpha;						//	AlphaBlend的混合过程，如果不计较精度，下面的/255可以用>>8来代替以提高点速度
			DestP[0] = (SrcP[0] * InvertAlpha + Table[SrcP[0]] * Alpha) / 255;	//  Blue分量
			DestP[1] = (SrcP[1] * InvertAlpha + Table[SrcP[1]] * Alpha) / 255;	//	Green分量
			DestP[2] = (SrcP[2] * InvertAlpha + Table[SrcP[2]] * Alpha) / 255;	//	Red分量
			DestP += 3;
			SrcP += 3;
			SkinP++;
		}
	}
	free(Table);
	free(Skin);
}

void SkinWhiteningUseLogCurve(unsigned char* src, unsigned char* dst, int width, int height, int stride, int level)
{
	int X, Y, Alpha, InvertAlpha;
	unsigned char *Table = (unsigned char *) malloc(256);
	unsigned char *Skin = (unsigned char *)malloc(width * height);
	unsigned char *SrcP, *DestP, *SkinP;
	GetSkinArea(src, Skin, width, height, stride);

	for (Y = 0; Y < 256; Y++)
	{
		Table[Y] = (int)(log(Y / 255.0 *(level - 1 ) + 1) /(log((double)level)) * 255);
	}
	for (Y = 0; Y < height; Y++)
	{
		SrcP = src + Y * stride;
		DestP = dst + Y * stride;
		SkinP = Skin + Y * width;
		for(X = 0; X < width; X++)
		{
			Alpha = SkinP[0]; InvertAlpha = 255 - Alpha;						//	AlphaBlend的混合过程，如果不计较精度，下面的/255可以用>>8来代替以提高点速度
			DestP[0] = (SrcP[0] * InvertAlpha + Table[SrcP[0]] * Alpha) / 255;	//  Blue分量
			DestP[1] = (SrcP[1] * InvertAlpha + Table[SrcP[1]] * Alpha) / 255;	//	Green分量
			DestP[2] = (SrcP[2] * InvertAlpha + Table[SrcP[2]] * Alpha) / 255;	//	Red分量
			DestP += 3;
			SrcP += 3;
			SkinP++;
		}
	}
	free(Table);
	free(Skin);
}

void SkinWhiteningFast(unsigned char* src, unsigned char* dst, int width, int height, int stride)
{
	int X, Y, Alpha, InvertAlpha, Blue, Green, Red, Intensity;
	unsigned char *Skin = (unsigned char *)malloc(width * height);
	unsigned char *SrcP, *DestP, *SkinP;
	GetSkinArea(src, Skin, width, height, stride);		//	获取大概的皮肤区域

	for (Y = 0; Y < height; Y++)
	{
		SrcP = src + Y * stride;
		DestP = dst + Y * stride;
		SkinP = Skin + Y * width;
		for(X = 0; X < width; X++)
		{
			Blue = SrcP[0]; Green = SrcP[1]; Red = SrcP[2];
			Intensity = (Red + Green + Green + Blue) / 4;
			Alpha = SkinP[0]; InvertAlpha = 255 - Alpha;						 //下面的公式的意思：复制一个图层，然后按照图像的内容创造选区，然后填充白色，谈后透明度设置为50%的优化结果
			DestP[0] = (Blue * InvertAlpha +  (Blue + (Intensity - Blue * Intensity / 255) / 2) * Alpha) / 255;	//  Blue分量
			DestP[1] = (Green * InvertAlpha + (Green + (Intensity - Green * Intensity / 255) / 2) * Alpha) / 255;	//	Green分量
			DestP[2] = (Red * InvertAlpha +  (Red + (Intensity - Red * Intensity / 255) / 2) * Alpha) / 255;	//	Red分量
			DestP += 3;
			SrcP += 3;
			SkinP++;
		}
	}
	free(Skin);
}

void DermabrasionFilter(unsigned char* src, unsigned char* dst, int width, int height, int stride, int acneRemovel)
{
	unsigned char *Skin = (unsigned char *)malloc(width * height);
	unsigned char *Clone = (unsigned char *)malloc(height * stride);						//	第一步，备份原始图像数据
	memcpy(Clone, src, height * stride);
	BiExponentialEPF(Clone, Clone, width, height,stride, 50, (float)acneRemovel);			//	第二步，对克隆的数据进行全局的磨皮，即不区分细节
	GetSkinArea(src, Skin, width, height, stride);											//	第三步，分析图像的大概的皮肤区域
	if (src != dst) memcpy(dst, src, height * stride);
	BlendImageWithMask(Clone, dst, Skin, width, height, stride, width);					//	第四步,对全局磨皮的图和原始图按照属于皮肤区域的程度进行混合
	UnsharpMask(dst, dst, width, height, stride, MAX(width, height) * 0.02, 20, 0);		//	第五步，此步可选，配置适当的参数可用于增强最终图像的清晰度等等。
	//SkinWhiteningUseLogCurve(dst, dst, width, height, stride, WhiteningLevel);			//	第六步，进行美白处理
	free(Clone);
	free(Skin);
}


void GuassBlur(unsigned char* src, unsigned char* dst, int width, int height,int stride, float radius)
{
	int ByteCount = stride / width;
	double Q, B, B0, B1, B2, B3;

	//计算相关系数

	if (radius >= 2.5)
		Q = (double)(0.98711 * radius - 0.96330);
	else if ((radius >= 0.5) && (radius < 2.5))
		Q = (double)(3.97156 - 4.14554 * sqrt(1 - 0.26891 * radius));
	else
		Q = (double)0.1147705018520355224609375;

	B0 = 1.57825 + 2.44413 * Q + 1.4281 * Q * Q + 0.422205 * Q * Q * Q;			//	论文公式8c
	B1 = 2.44413 * Q + 2.85619 * Q * Q + 1.26661 * Q * Q * Q;
	B2 = -1.4281 * Q * Q - 1.26661 * Q * Q * Q;
	B3 = 0.422205 * Q * Q * Q;
	B = 1.0 - (B1 + B2 + B3) / B0;
	B1 = B1 / B0;
	B2 = B2 / B0;
	B3 = B3 / B0;

	//计算相关系数 end

	int CoreNum = (width * height) / 160000;							//	400*400个像素使用一个核心
//	if (CoreNum > omp_get_num_procs()) CoreNum = omp_get_num_procs();	//	此处最好使用和物理核心数相同的线程数量
//	LOGI("GuassBlur coreNum=%d", CoreNum);
	//水平方向处理
	{
		#pragma omp parallel for num_threads(CoreNum)					//	由于CPU的缓存的cache miss问题，同样的算法水平方向的要比垂直方向的快

		for (int K = 0; K < CoreNum; K++)
		{
			int X, Y, Start, End;
			double *Wp1, *Wp2, *W1, *W2;
			unsigned char *SrcP, *DestP;
			Start = K * height / CoreNum;
			End = (K + 1) * height / CoreNum;
			if (End > height) End = height;

			W1 = (double *)malloc((width + 6) * ByteCount * sizeof(double));
			W2 = (double *)malloc((width + 6)* ByteCount * sizeof(double));

			if (ByteCount == 1)			//	灰度图像
			{
				for (Y = Start; Y < End; Y++)
				{
					SrcP = src + Y * stride;
					Wp1 = W1; Wp2 = W2 + width + 5;
					for (X = 0; X < 3; X++)
					{
						Wp1[0] = SrcP[0];				// 起始三个点赋值为第一个像素点的值
						Wp1++;
					}
					for (X = 0; X < width; X++)
					{
						Wp1[0] = SrcP[0] * B + Wp1[-1] * B1 + Wp1[-2] * B2 + Wp1[-3] * B3;              // 进行迭代,论文公式9a
						Wp1++;
						SrcP++;
					}
					SrcP--;							// 执行完上面的循环后Pointer已经指向下一行的像素或者一个扫描行尾部的无效像素了。
					for (X = 0; X < 3; X++)
					{
						Wp1[0] = SrcP[0] * B + Wp1[-1] * B1 + Wp1[-2] * B2 + Wp1[-3] * B3;
						Wp1++;
					}
					Wp1--;							//  Wp1指针已经指到最后了

					for (X = 0; X < 3; X++)         //  反向传播
					{
						Wp2[0] = Wp1[0];
						Wp2--; Wp1--;
					}

					DestP = dst + Y * stride + width - 1;
					for (X = 0; X < width; X++)
					{
						Wp2[0] = Wp1[0] * B + Wp2[1] * B1 + Wp2[2] * B2 + Wp2[3] * B3;			//论文公式9b
						DestP[0] = Wp2[0];
						Wp2--;
						Wp1--;
						DestP--;
					}
				}
			}
			else if (ByteCount == 3)
			{
				for (Y = 0; Y < height; Y++)
				{
					SrcP = src + Y * stride;
					Wp1 = W1; Wp2 = W2 + width * 3 + 15;
					for (X = 0; X < 3; X++)
					{
						Wp1[0] = SrcP[0]; Wp1[1] = SrcP[1]; Wp1[2] = SrcP[2];      // 起始三个点赋值为第一个像素点的值，不然会造成图像整体便宜
						Wp1 += 3;
					}
					for (X = 0; X < width; X++)
					{
						Wp1[0] = SrcP[0] * B + Wp1[-3] * B1 + Wp1[-6] * B2 + Wp1[-9] * B3;
						Wp1[1] = SrcP[1] * B + Wp1[-2] * B1 + Wp1[-5] * B2 + Wp1[-8] * B3;		 // 进行迭代
						Wp1[2] = SrcP[2] * B + Wp1[-1] * B1 + Wp1[-4] * B2 + Wp1[-7] * B3;
						Wp1 += 3;
						SrcP += 3;
					}
					SrcP -= 3;                    // 执行完上面的循环后Pointer已经指向下一行的像素或者一个扫描行尾部的无效像素了。

					for (X = 0; X < 3; X++)
					{
						Wp1[0] = SrcP[0] * B + Wp1[-3] * B1 + Wp1[-6] * B2 + Wp1[-9] * B3;
						Wp1[1] = SrcP[1] * B + Wp1[-2] * B1 + Wp1[-5] * B2 + Wp1[-8] * B3;
						Wp1[2] = SrcP[2] * B + Wp1[-1] * B1 + Wp1[-4] * B2 + Wp1[-7] * B3;
						Wp1 += 3;
					}

					Wp1 -= 3;                       //  Wp1指针已经指到最后了
					for (X = 0; X < 3; X++)         //  反向传播
					{
						Wp2[0] = Wp1[0]; Wp2[1] = Wp1[1]; Wp2[2] = Wp1[2];
						Wp2 -= 3; Wp1 -= 3;
					}
					DestP = dst + Y * stride + (width - 1) * 3;
					for (X = 0; X < width; X++)
					{
						Wp2[0] = Wp1[0] * B + Wp2[3] * B1 + Wp2[6] * B2 + Wp2[9] * B3;
						Wp2[1] = Wp1[1] * B + Wp2[4] * B1 + Wp2[7] * B2 + Wp2[10] * B3;
						Wp2[2] = Wp1[2] * B + Wp2[5] * B1 + Wp2[8] * B2 + Wp2[11] * B3;

						DestP[0] = Wp2[0];
						DestP[1] = Wp2[1];				//	从数值精度方面考虑，这里应该用个double类型的数组来保存，但是从速度考虑，这里用原始的内存
						DestP[2] = Wp2[2];				//	使用隐式的类型转换

						Wp2 -= 3;
						Wp1 -= 3;
						DestP -= 3;
					}
				}
			}
			free (W1);
			free (W2);
		}
	}
	//水平方向处理 end

	//垂直方向处理
	{
		#pragma omp parallel for num_threads(CoreNum)
		for (int K = 0; K < CoreNum; K++)
		{
			int X, Y, Start, End;
			double *Wp1, *Wp2, *W1, *W2;
			unsigned char *SrcP, *DestP;
			Start = K * width / CoreNum;
			End = (K + 1) * width / CoreNum;
			if (End > width) End = width;

			W1 = (double*)malloc((height + 6) * 3 * sizeof(double));
			W2 = (double*)malloc((height + 6) * 3 * sizeof(double));

			if (ByteCount == 1)
			{
				for (X = Start; X < End; X++)
				{
					DestP = dst + X;							//	注意这里是对处理后的数据在进行处理了
					Wp1 = W1;	Wp2 = W2 + height + 5; ;
					for (Y = 0; Y < 3; Y++)
					{
						Wp1[0] = DestP[0];
						Wp1++;
					}
					for (Y = 0; Y < height; Y++)
					{
						Wp1[0] = DestP[0] * B + Wp1[-1] * B1 + Wp1[-2] * B2 + Wp1[-3] * B3;
						Wp1++;
						DestP += stride;
					}
					DestP -= stride;
					for (Y = 0; Y < 3; Y++)
					{
						Wp1[0] = DestP[0] * B + Wp1[-1] * B1 + Wp1[-2] * B2 + Wp1[-3] * B3;
						Wp1++;
					}
					Wp1--;
					for (Y = 0; Y < 3; Y++)
					{
						Wp2[0] = Wp1[0];
						Wp2--; Wp1--;
					}
					for (Y = 0; Y < height; Y++)
					{
						Wp2[0] = Wp1[0] * B + Wp2[1] * B1 + Wp2[2] * B2 + Wp2[3] * B3;
						DestP[0] = Wp2[0];
						Wp2--;
						Wp1--;
						DestP -= stride;
					}
				}
			}
			else if (ByteCount == 3)
			{
				for (X = Start; X < End; X++)
				{
					DestP = dst + X * 3;
					Wp1 = W1;	Wp2 = W2 + height * 3 + 15; ;
					for (Y = 0; Y < 3; Y++)
					{
						Wp1[0] = DestP[0]; Wp1[1] = DestP[1]; Wp1[2] = DestP[2];
						Wp1 += 3;
					}

					for (Y = 0; Y < height; Y++)
					{
						Wp1[0] = DestP[0] * B + Wp1[-3] * B1 + Wp1[-6] * B2 + Wp1[-9] * B3;
						Wp1[1] = DestP[1] * B + Wp1[-2] * B1 + Wp1[-5] * B2 + Wp1[-8] * B3;
						Wp1[2] = DestP[2] * B + Wp1[-1] * B1 + Wp1[-4] * B2 + Wp1[-7] * B3;
						Wp1 += 3;
						DestP += stride;
					}
					DestP -= stride;
					for (Y = 0; Y < 3; Y++)
					{
						Wp1[0] = DestP[0] * B + Wp1[-3] * B1 + Wp1[-6] * B2 + Wp1[-9] * B3;
						Wp1[1] = DestP[1] * B + Wp1[-2] * B1 + Wp1[-5] * B2 + Wp1[-8] * B3;
						Wp1[2] = DestP[2] * B + Wp1[-1] * B1 + Wp1[-4] * B2 + Wp1[-7] * B3;
						Wp1 += 3;
					}
					Wp1 -= 3;
					for (Y = 0; Y < 3; Y++)
					{
						Wp2[0] = Wp1[0]; Wp2[1] = Wp1[1]; Wp2[2] = Wp1[2];
						Wp2 -= 3; Wp1 -= 3;
					}
					for (Y = 0; Y < height; Y++)
					{
						Wp2[0] = Wp1[0] * B + Wp2[3] * B1 + Wp2[6] * B2 + Wp2[9] * B3;
						Wp2[1] = Wp1[1] * B + Wp2[4] * B1 + Wp2[7] * B2 + Wp2[10] * B3;
						Wp2[2] = Wp1[2] * B + Wp2[5] * B1 + Wp2[8] * B2 + Wp2[11] * B3;

						DestP[0] = Wp2[0];
						DestP[1] = Wp2[1];
						DestP[2] = Wp2[2];
						Wp2 -= 3;
						Wp1 -= 3;
						DestP -= stride;
					}
				}
			}
			free (W1);
			free (W2);
		}
	}
	//垂直方向处理 end
}

void GetSkinArea(unsigned char* src, unsigned char* skin, int width, int height, int stride)
{
	int X, Y;
    unsigned char *SrcP, *SkinP;

	memset(skin, 32, width * height);		//	一般来说，不管是不是需要头发或者其他细节，我们都还是给她磨掉一点吧，我喜欢32这种数字，所以取了32

	for (Y = 0; Y < height; Y++)
    {
        SrcP = src + Y * stride;
        SkinP = skin + Y * width;
        for (X = 0; X < width; X++)
        {
            if (SrcP[0] >50 && SrcP[1] > 40 && SrcP[2] > 20) SkinP[0] = 255;  //	为什么取这些数据，我只能告诉这些数据是前人的一些经验没有什么数学公式来推导和证明的
            SrcP += 3;
            SkinP++;
        }
    }
	GuassBlur(skin, skin, width, height, width, MAX(width, height) * 0.02);		//	对得到的皮肤和非皮肤的硬边界做羽化，让后续的变化平滑
}

void BEEPSHorizontalVertical(float *data, int width, int height, float spatialContraDecay, float photometricStandardDeviation)
{
    int X, Y, I, J, M, N, StartIndex;
    float Rho = 1.0 + spatialContraDecay;													// (1+λ)
    float InvRho = 1 / Rho;																	// 1/(1+λ)
	float C = -0.5 / (photometricStandardDeviation * photometricStandardDeviation);			// -1/(2*σ*σ)
    float Cof = (1.0 - spatialContraDecay) / (1.0 + spatialContraDecay);					// (1-λ)/(1+λ)
	float Value;

    float* Progressive = (float*)malloc(width * height * sizeof(float));
    float* Gain = (float*)malloc(width * height * sizeof(float));
    float* Regressive = (float*)malloc(width * height * sizeof(float));

    memcpy(Progressive, data, width * height * sizeof(float));					//	拷贝原始数据
    memcpy(Gain, data, width * height * sizeof(float));							//	拷贝原始数据
    memcpy(Regressive, data, width * height * sizeof(float));					//	拷贝原始数据

    for (Y = 0; Y < height; Y++)                                                // 水平方向的处理
    {
        StartIndex = Y * width;
        Progressive[StartIndex] *= InvRho;										// 每一行第一个像素做特别处理，见论文公式（6），* InvRho是在公式（6）的基础上直接算公式（5）的ψ[k]/(1+λ)
        for (X = StartIndex + 1; X < StartIndex + width; X++)                   // 顺向逐步递推
        {
            Value = Progressive[X] - Rho * Progressive[X - 1];					// 计算值域的差异，这个步骤有点难以理解
            Value = spatialContraDecay * exp(C * Value * Value);				// exp计算的结果即为值域的权重，此项为公式（1）中的λ*Q[k]项
            Progressive[X] = Progressive[X - 1] * Value + Progressive[X] * (1.0 - Value) * InvRho;	// 对应公式（1），但最后一个*InvRho?
        }

        Regressive[StartIndex + width - 1] *= InvRho;	                        // 逆向回归递推，这一句对应公式（7）
        for (X = StartIndex + width - 2; StartIndex <= X; X--)
        {
            Value = Regressive[X] - Rho * Regressive[X + 1];
            Value = spatialContraDecay * exp(C * Value * Value);				// exp计算的结果即为值域的权重，此项为公式（5）中的λ*ρ[k]项
            Regressive[X] = Regressive[X + 1] * Value + Regressive[X] * (1.0f - Value) * InvRho;
        }
    }
    for (Y = 0; Y < width * height; Y++)  Regressive[Y] += Progressive[Y] - Gain[Y] * Cof;          //  Gain[X] * Cof是Gain项,此式对应论文中的公式5，注意Progressive和Regressive在之前的计算中都已经/(1+λ)了

	//	水平方向直行完毕，直行的结果保存在Regressive这个数组里面，下面开始垂直方向直行，注意垂直方面处理是对水平方向处理处理后的数据进行的

    for (J = 0, M = 0; J < height; J++)
    {
        N = J;
        for (I = 0; I < width; I++)										//	Progressive中此时保存了Regressive旋转后的数据，为什么要旋转？
        {
            Progressive[N] = Regressive[M++];							//	1、旋转后数据处理的代码上水平方向就完全相似，除了二层循环的范围调换了以外
            N += height;												//	2、旋转后的数据在访问时基本是连续的，提高了缓存的命中率，虽然会多了2次旋转，但总体速度会提高
        }
    }
    memcpy(Regressive, Progressive, width * height * sizeof(float));	// 同样对数据复制
    memcpy(Gain, Progressive, width * height * sizeof(float));

    for (Y = 0; Y < width; Y++)
    {
        StartIndex = Y * height;
        Progressive[StartIndex]  *= InvRho;
        for (X = StartIndex + 1; X < StartIndex + height; X++)
        {
            Value = Progressive[X] - Rho * Progressive[X - 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Progressive[X] = Progressive[X - 1] * Value + Progressive[X] * (1.0f - Value) * InvRho;
        }

        Regressive[StartIndex + height - 1] *= InvRho;
        for (X = StartIndex + height - 2; StartIndex <= X; X--)
        {
            Value = Regressive[X] - Rho * Regressive[X + 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Regressive[X] = Regressive[X + 1] * Value + Regressive[X] * (1.0f - Value) * InvRho;
        }
    }
    for (Y = 0; Y < width * height; Y++) Regressive[Y] += Progressive[Y] - Gain[Y] * Cof;
	//	上面这段代码和水平处理的意思是一样的，只不过二层循环的范围调换了而已

    for (J = 0, M = 0; J < width; J++)
    {
        N = J;
        for (I = 0; I < height; I++)
        {
            data[N] = Regressive[M++];			//	注意最终的数据还需要旋转回来
            N += width;
        }
    }

    free(Progressive);
    free(Gain);
    free(Regressive);
}


void BEEPSVerticalHorizontal(float* data, int width, int height, float spatialContraDecay, float photometricStandardDeviation)
{
	int X, Y, I, J, M, N, StartIndex;
    float C = -0.5f / (photometricStandardDeviation * photometricStandardDeviation);
    float Rho = 1.0f + spatialContraDecay;
    float InvRho = 1 / Rho;
    float Value;
    float Cof = (1.0f - spatialContraDecay) / (1.0f + spatialContraDecay);

    float* Progressive = (float*)malloc( width * height * sizeof(float));
    float* Gain = (float*)malloc( width * height * sizeof(float));
    float* Regressive = (float*)malloc( width * height * sizeof(float));

    for (J = 0, M = 0; J < height; J++)
    {
        for (I = 0, N = J; I < width; I++)
        {
            Progressive[N] = data[M++];
            N += height;
        }
    }
    memcpy(Gain, Progressive, width * height * sizeof(float));
    memcpy(Regressive, Progressive, width * height * sizeof(float));

    for (Y = 0; Y < width; Y++)
    {
        StartIndex = Y * height;
        Progressive[StartIndex] *= InvRho;
        for (X = StartIndex + 1; X < StartIndex + height; X++)
        {
            Value = Progressive[X] - Rho * Progressive[X - 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Progressive[X] = Progressive[X - 1] * Value + Progressive[X] * (1.0f - Value) * InvRho;
        }

        Regressive[StartIndex + height - 1] /= Rho;
        for (X = StartIndex + height - 2; StartIndex <= X; X--)
        {
            Value = Regressive[X] - Rho * Regressive[X + 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Regressive[X] = Regressive[X + 1] * Value + Regressive[X] * (1.0f - Value) * InvRho;
        }
    }
    for (Y = 0; Y < width * height; Y++) Regressive[Y] += Progressive[Y] - Gain[Y] * Cof;

    for (J = 0, M = 0; J < width; J++)
    {
        for (I = 0, N = J; I < height; I++)
        {
            Progressive[N] = Regressive[M++];
            N += width;
        }
    }

    memcpy(Gain, Progressive, width * height * sizeof(float));
    memcpy(Regressive, Progressive, width * height * sizeof(float));

    for (Y = 0; Y < height; Y++)
    {
        StartIndex = Y * width;
        Progressive[StartIndex] /= Rho;
        for (X = StartIndex + 1; X < StartIndex + width; X++)
        {
            Value = Progressive[X] - Rho * Progressive[X - 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Progressive[X] = Progressive[X - 1] * Value + Progressive[X] * (1.0f - Value) * InvRho;
        }

        Regressive[StartIndex + width - 1] /= Rho;
        for (X = StartIndex + width - 2; StartIndex <= X; X--)
        {
            Value = Regressive[X] - Rho * Regressive[X + 1];
            Value = spatialContraDecay * exp(C * Value * Value);
            Regressive[X] = Regressive[X + 1] * Value + Regressive[X] * (1.0f - Value) * InvRho;
        }
    }

	for (Y = 0; Y < width * height; Y++) data[Y] = Regressive[Y] + Progressive[Y] - Gain[Y] * Cof;
    free(Progressive);
    free(Gain);
    free(Regressive);
}

void BiExponentialEPF(unsigned char* src, unsigned char* dst, int width, int height, int stride, float spatialContraDecay, float photometricStandardDeviation)
{
	int X, Y, Index;
	int ByteCount = stride / width;
//	LOGI("BiExponentialEPF ByteCount=%d", ByteCount);
	unsigned char *SrcP, *DestP;
	spatialContraDecay = ( 1 - (sqrt(2.0 * spatialContraDecay * spatialContraDecay + 1) - 1) / (spatialContraDecay * spatialContraDecay));			//	这个对应Beeps论文的公式(33)
	if (ByteCount == 1)
	{
		float Value;
		float* ImageDataH = (float*)malloc(width * height * sizeof(float));
		 float* ImageDataV = (float*)malloc(width * height * sizeof(float));
		for (Y = 0, Index = 0; Y < height; Y++)
		{
			SrcP = src + Y * stride;
			for (X = 0; X < width; X++, Index++) ImageDataH[Index] = SrcP[X];				//	转换为浮点数
		}
		memcpy(ImageDataV, ImageDataH, width * height * sizeof(float));

		#pragma omp parallel sections  num_threads(omp_get_num_procs())
		{
			#pragma omp  section															//	这两个过程是理论耗时是完全一样的，且数据之间毫无干涉，完全可以并行执行
				BEEPSHorizontalVertical(ImageDataH, width, height, spatialContraDecay, photometricStandardDeviation);
			#pragma omp  section
				BEEPSVerticalHorizontal(ImageDataV, width, height, spatialContraDecay, photometricStandardDeviation);
		}

		for (Y = 0, Index = 0; Y < height; Y++)
		{
			DestP = dst + Y * stride;
			for (X = 0; X < width; X++, Index++)
			{
				Value = (ImageDataH[Index] + ImageDataV[Index]) * 0.5;			//	对处理的结果进行合并
				if (Value > 255)												//	防止数据溢出
					Value = 255;
				else if (Value < 0)
					Value = 0;
				DestP[X] = Value;
			}
		}
		free(ImageDataH);
		free(ImageDataV);
	}
	else if (ByteCount == 3)				// 拆分成3个通道的数据，然后利用多线程进行加速
	{
		float ValueB, ValueG, ValueR;
		float* ImageDataHB = (float*)malloc( width * height * sizeof(float));
		float* ImageDataVB = (float*)malloc( width * height * sizeof(float));
		float* ImageDataHG = (float*)malloc( width * height * sizeof(float));
		float* ImageDataVG = (float*)malloc( width * height * sizeof(float));
		float* ImageDataHR = (float*)malloc( width * height * sizeof(float));
		float* ImageDataVR = (float*)malloc( width * height * sizeof(float));
		for (Y = 0, Index = 0; Y < height; Y++)
		{
			SrcP = src + Y * stride;
			for (X = 0; X < width; X++, Index++)
			{
				ImageDataHB[Index] = SrcP[0];
				ImageDataHG[Index] = SrcP[1];
				ImageDataHR[Index] = SrcP[2];
				SrcP += 3;
			}
		}

		memcpy(ImageDataVB, ImageDataHB, width * height * sizeof(float));
		memcpy(ImageDataVG, ImageDataHG, width * height * sizeof(float));
		memcpy(ImageDataVR, ImageDataHR, width * height * sizeof(float));

		#pragma omp parallel sections  num_threads(omp_get_num_procs())
		{
			#pragma omp section
			{
				BEEPSHorizontalVertical(ImageDataHB, width, height, spatialContraDecay, photometricStandardDeviation);
				BEEPSVerticalHorizontal(ImageDataVB, width, height, spatialContraDecay, photometricStandardDeviation);
			}
			#pragma omp section
			{
				BEEPSHorizontalVertical(ImageDataHG, width, height, spatialContraDecay, photometricStandardDeviation);
				BEEPSVerticalHorizontal(ImageDataVG, width, height, spatialContraDecay, photometricStandardDeviation);
			}
			#pragma omp section
			{
				BEEPSHorizontalVertical(ImageDataHR, width, height, spatialContraDecay, photometricStandardDeviation);
				BEEPSVerticalHorizontal(ImageDataVR, width, height, spatialContraDecay, photometricStandardDeviation);
			}
		}
		for (Y = 0, Index = 0; Y < height; Y++)
		{
			DestP = dst + Y * stride;
			for (X = 0; X < width; X++, Index++)
			{
				ValueB = (ImageDataHB[Index] + ImageDataVB[Index]) * 0.5;
				ValueG = (ImageDataHG[Index] + ImageDataVG[Index]) * 0.5;
				ValueR = (ImageDataHR[Index] + ImageDataVR[Index]) * 0.5;
				if (ValueB > 255)
					ValueB = 255;
				else if (ValueB < 0)
					ValueB = 0;
				if (ValueG > 255)
					ValueG = 255;
				else if (ValueG < 0)
					ValueG = 0;
				if (ValueR > 255)
					ValueR = 255;
				else if (ValueR < 0)
					ValueR = 0;
				DestP[0] = ValueB;
				DestP[1] = ValueG;
				DestP[2] = ValueR;
				DestP += 3;
			}
		}
		free(ImageDataHG);
		free(ImageDataVG);
		free(ImageDataHR);
		free(ImageDataVR);
		free(ImageDataHB );
		free(ImageDataVB);
	}
}

void BlendImageWithMask(unsigned char* src, unsigned char* dst, unsigned char* mask, int width, int height, int stride, int maskStride)
{
	int ByteCount = stride / width;
	int X, Y, Alpha, InvertAlpha;
	unsigned char * SrcP, * DestP, * MaskP;
	if (ByteCount == 1)
	{
		for (Y = 0; Y < height; Y++)
		{
			SrcP = src + Y * stride;											//	用乘以Stride来跳过一行像素可能存在的系统自动补齐的部分
			DestP = dst + Y * stride;
			MaskP = mask + Y * maskStride;
			for (X = 0; X < width; X++)
			{
				Alpha = mask[0]; InvertAlpha = 255 - Alpha;						//	AlphaBlend的混合过程，如果不计较精度，下面的/255可以用>>8来代替以提高点速度
				DestP[0] = (DestP[0] * InvertAlpha + SrcP[0] * Alpha) / 255;
				SrcP++;															//	移动到下一个像素
				DestP++;
				mask++;															//	移动到下一个Mask值
			}
		}
	}
	else if (ByteCount == 3)
	{
		for (Y = 0; Y < height; Y++)
		{
			SrcP = src + Y * stride;											//	用乘以Stride来跳过一行像素可能存在的系统自动补齐的部分
			DestP = dst + Y * stride;
			MaskP = mask + Y * maskStride;
			for (X = 0; X < width; X++)
			{
				Alpha = mask[0]; InvertAlpha = 255 - Alpha;						//	AlphaBlend的混合过程，如果不计较精度，下面的/255可以用>>8来代替以提高点速度
				DestP[0] = (DestP[0] * InvertAlpha + SrcP[0] * Alpha) / 255;	//  Blue分量
				DestP[1] = (DestP[1] * InvertAlpha + SrcP[1] * Alpha) / 255;	//	Green分量
				DestP[2] = (DestP[2] * InvertAlpha + SrcP[2] * Alpha) / 255;	//	Red分量
				SrcP += 3;														//	移动到下一个像素，24位
				DestP += 3;
				mask++;															//	移动到下一个Mask值
			}
		}
	}
}

void UnsharpMask(unsigned char* src, unsigned char* dst, int width, int height, int stride, float radius, int amount, int threshold)
{
	int X, Y, Diff, Value, Index;
	int ByteCount = stride / width;
	unsigned char *Blur = (unsigned char*)malloc(height * stride);

	GuassBlur(src, Blur, width, height, stride, radius);

	if (ByteCount == 1)
	{
		for (Y = 0; Y < height; Y++)
		{
			Index = Y * stride;
			for (X = 0; X < width; X++, Index++)
			{
				Diff = src[Index] - Blur[Index];
				if (abs(Diff) >= threshold)
				{
					Value = src[Index] + amount * Diff / 100;
					dst[Index] = Clamp(Value);
				}
				else
					dst[Index] = src[Index];
				Index += 3;
			}
		}
	}
	else if (ByteCount == 3)
	{
		for (Y = 0; Y < height; Y++)
		{
			Index = Y * stride;
			for (X = 0; X < width; X++, Index += 3)
			{
				Diff = src[Index] - Blur[Index];
				if (abs(Diff) >= threshold)
				{
					Value = src[Index] + amount * Diff / 100;
					dst[Index] = Clamp(Value);
				}
				else
					dst[Index] = src[Index];

				Diff = src[Index + 1] - Blur[Index + 1];
				if (abs(Diff) >= threshold)
				{
					Value = src[Index + 1] + amount * Diff / 100;
					dst[Index + 1] = Clamp(Value);
				}
				else
					dst[Index + 1] =  src[Index + 1];

				Diff = src[Index + 2] - Blur[Index + 2];
				if (abs(Diff) >= threshold)
				{
					Value = src[Index + 2] + amount * Diff / 100;
					dst[Index + 2] = Clamp(Value);
				}
				else
					dst[Index + 2] =  src[Index + 2];

			}
		}
	}
	free(Blur);
}
