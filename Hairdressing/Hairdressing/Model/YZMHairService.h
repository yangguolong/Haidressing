

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@protocol YZMHairService <NSObject>

/** 获取区域列表 */
- (RACSignal *)getArea;




/**
 *  获取门店列表
 *
 *  @param sortType   排序类型：1:智能排序     3:人气最高  2:离我最近     4:技术最好
 *  @param districtId 区、县的行政编码
 *  @param townId     镇、乡、街道的ID
 *  @param distance   距离，与上述经度纬度描述地址的相隔距离。单位M
 *  @param pNo        页码,从第1页开始
 *  @param pSize      每页记录数
 *
 *  @return
 */
- (RACSignal *)getHairstylistWithSortType:(NSNumber *)sortType
                            districtId:(NSString *)districtId
                                townId:(NSString *)townId
                              distance:(long long)distance
                                   pNo:(long long)pNo
                                 pSize:(long long)pSize
                             longitude:(double)longitude
                              latitude:(double)latitude;
/**
 *  获取门店列表
 *
 *  @param sortType   排序类型：1:智能排序     3:人气最高  2:离我最近     4:技术最好
 *  @param districtId 区、县的行政编码
 *  @param townId     镇、乡、街道的ID
 *  @param distance   距离，与上述经度纬度描述地址的相隔距离。单位M
 *  @param pNo        页码,从第1页开始
 *  @param pSize      每页记录数
 *
 *  @return
 */
- (RACSignal *)getCorplistWithSortType:(NSNumber *)sortType
                            districtId:(NSString *)districtId
                                townId:(NSString *)townId
                              distance:(long long)distance
                                   pNo:(long long)pNo
                                 pSize:(long long)pSize
                             longitude:(double)longitude
                              latitude:(double)latitude
                           corporation:(NSString *)corporation;

@end