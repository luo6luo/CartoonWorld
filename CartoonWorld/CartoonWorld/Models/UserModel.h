//
//  UserModel.h
//  CartoonWorld
//
//  Created by dundun on 2017/11/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import <Realm/Realm.h>
@class ComicModel;
@class StringObject;

// 添加了协议才能使用RLMArray功能
RLM_ARRAY_TYPE(ComicModel);
RLM_ARRAY_TYPE(StringObject);

// https://www.jianshu.com/p/50e0efb66bdf
@interface UserModel : RLMObject<NSCopying>

/**用户id*/
@property NSInteger userID;
/**昵称*/
@property NSString *nickName;
/**描述*/
@property NSString *descriptionStr;
/**头像*/
@property NSData *headerIcon;
/**收藏夹（存漫画model）*/
@property RLMArray<ComicModel *><ComicModel> *favorites;
/**搜索历史(存字符串)*/
@property RLMArray<StringObject *><StringObject> *searchHistories;

/**获取用户对象*/
+ (UserModel *)defaultUser;

@end
