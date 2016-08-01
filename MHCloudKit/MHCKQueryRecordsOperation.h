//
//  MHCKQueryRecordsOperation.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 01/08/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <MHFoundation/MHFSerialQueueAsyncOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHCKQueryRecordsOperation : MHFSerialQueueAsyncOperation

- (instancetype)initWithRecordIDs:(NSArray <CKRecordID *> *)recordIDs;

@property (nonatomic, copy, nullable) NSArray <CKRecordID *> *recordIDs;

/* This block will be called once for every record batch that is returned as a result of the query. */
@property (nonatomic, copy, nullable) void (^recordsFetchedBlock)(NSDictionary <CKRecordID *, CKRecord *> * recordsByRecordID);

/*  This block is called when the operation completes.
 The [NSOperation completionBlock] will also be called if both are set. */
@property (nonatomic, copy, nullable) void (^queryCompletionBlock)(NSError * __nullable operationError);

@end

NS_ASSUME_NONNULL_END