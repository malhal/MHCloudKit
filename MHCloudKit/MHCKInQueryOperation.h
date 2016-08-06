//
//  MHCKInQueryOperation.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 01/08/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <MHFoundation/MHFSerialQueueOperation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 With CloudKit there is a limit to the number of values that can appear in an IN query (about 130) so this class
 allows the query to be batched.
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

/* This block will be called once for every record batch that is returned as a result of the query. */
@property (nonatomic, copy, nullable) void (^recordsFetchedBlock)(NSArray <CKRecord *> * records);

/*  This block is called when the operation completes.
 The [NSOperation completionBlock] will also be called if both are set. */
@property (nonatomic, copy, nullable) void (^inQueryCompletionBlock)(NSError * __nullable operationError);

@end

NS_ASSUME_NONNULL_END