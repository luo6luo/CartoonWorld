//
//  ComicCommentController.h
//  CartoonWorld
//
//  Created by dundun on 2017/7/7.
//  Copyright © 2017年 顿顿. All rights reserved.
//

#import "ComicBaseScrollView.h"

typedef NS_ENUM(NSInteger, CommentScrollDirection) {
    CommentUp = 1,
    CommentDown,
    CommentOther
};

@interface ComicCommentController : ComicBaseScrollView

@property (nonatomic, assign) NSInteger comicId;   // 漫画id
@property (nonatomic, assign) NSInteger thread_id; // 线程id

- (void)loadNewCommentData;

@end
