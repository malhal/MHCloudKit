//
//  MHCKInQueryOperation.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 01/08/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <MHCloudKit/MHCKDefines.h>
#import <MHFoundation/MHFSerialQueueOperation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 With CloudKit there is a limit to the number of values that can appear in an IN query (250 but gives internal server error between 193-250) so this class
 allows the query to be batched by limiting it to 100.
 "Limit Exceeded" (27/2023); server message = "Query filter exceeds the limit of values: 250 for container 'iCloud.com.malhal.MHCloudSyncDemo"
 Internal server error on other numbers, see above when the IN query failed on 193 entries.
 */
@interface MHCKInQueryOperation : MHFSerialQueueOperation

- (instancetype)initWithRecordType:(nullable NSString *)recordType key:(nullable NSString *)key values:(nullable NSArray <__kindof id <CKRecordValue>> *)values;

@property (nonatomic, copy, nullable) NSString *recordType;

@property (nonatomic, copy, nullable) NSString *key;

@property (nonatomic, copy, nullable) NSArray <__kindof id <CKRecordValue>> *values;

@property (nonatomic, assign) BOOL notIn;

@property (nonatomic, copy, nullable) NSArray <NSPredicate *> *andSubpredicates;

@property (nonatomic, copy, nullable) NSArray <NSSortDescriptor *> *sortDescriptors;

@property (nonatomic, strong, nullable) CKDatabase *database;

@property (nonatomic, copy, nullable) void (^subarrayBlock)(NSArray <__kindof id <CKRecordValue>> *values);

/* This block will be called once for every record batch that is returned as a result of the query. */
@property (nonatomic, copy, nullable) void (^recordsFetchedBlock)(NSArray <CKRecord *> * records);

/*  This block is called when the operation completes.
 The [NSOperation completionBlock] will also be called if both are set. */
@property (nonatomic, copy, nullable) void (^inQueryCompletionBlock)(NSError * __nullable operationError);

@end

NS_ASSUME_NONNULL_END