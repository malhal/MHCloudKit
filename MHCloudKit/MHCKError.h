//
//  MHCKError.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 23/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MHCloudKit/MHCKDefines.h>

NS_ASSUME_NONNULL_BEGIN

MHCLOUDKIT_EXTERN NSString * const MHCloudKitErrorDomain;

typedef NS_ENUM(NSInteger, MHFErrorCode) {
    MHCKErrorUnknown                = 1,  /* Unknown or generic error */
    MHCKErrorInvalidArguments       = 12,
    MHCKErrorOperationCancelled     = 20,  /* A MHCK operation was explicitly cancelled */
};

NS_ASSUME_NONNULL_END