//
//  MHFullQueryOperation.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 11/04/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
//  Does multiple query cursor operations to get all the records.

#import <CloudKit/CloudKit.h>
#import <MHFoundation/MHFSerialQueueAsyncOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHCKFullQueryOperation : MHFSerialQueueAsyncOperation

- (instancetype)initWithQuery:(CKQuery *)query;

@property (nonatomic, copy, nullable) CKQuery *query;

@property (nonatomic, strong, nullable) CKDatabase *database;

/* This block will be called once for every record batch that is returned as a result of the query. */
@property (nonatomic, copy, nullable) void (^recordsFetchedBlock)(NSDictionary <CKRecordID *, CKRecord *> * recordsByRecordID);

/*  This block is called when the operation completes.
 The [NSOperation completionBlock] will also be called if both are set. */
@property (nonatomic, copy, nullable) void (^queryCompletionBlock)(NSError * __nullable operationError);

@end
NS_ASSUME_NONNULL_END