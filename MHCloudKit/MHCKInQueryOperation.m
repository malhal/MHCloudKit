//
//  MHCKInQueryOperation.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 01/08/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHCKInQueryOperation.h"
#import "MHCKFullQueryOperation.h"
#import "MHCKError.h"
#import "NSError+MHF.h"

#define MAX_VALUES_TO_QUERY 100

@implementation MHCKInQueryOperation

- (instancetype)initWithRecordType:(NSString *)recordType key:(NSString *)key values:(NSArray <__kindof id <CKRecordValue>> *)values{
    self = [super init];
    if (self) {
        _recordType = recordType.copy;
        _key = key.copy;
        _values = values.copy;
    }
    return self;
}

-(BOOL)asyncOperationShouldRun:(NSError *__autoreleasing *)error{
    // todo check if these should be consistency exceptions.
    if(!self.recordType){
        *error = [NSError mhf_errorWithDomain:MHCloudKitErrorDomain code:MHCKErrorInvalidArguments descriptionFormat:@"a recordType must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    else if(!self.database){
        *error = [NSError mhf_errorWithDomain:MHCloudKitErrorDomain code:MHCKErrorInvalidArguments descriptionFormat:@"a database must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    else if(!self.values){
        *error = [NSError mhf_errorWithDomain:MHCloudKitErrorDomain code:MHCKErrorInvalidArguments descriptionFormat:@"values must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    return [super asyncOperationShouldRun:error];
}

-(void)performAsyncOperation{
    for(int i = 0; i < self.values.count; i += MAX_VALUES_TO_QUERY) {
        NSArray *subarray = [self.values subarrayWithRange:NSMakeRange(i, MIN(MAX_VALUES_TO_QUERY, self.values.count - i))];
        if(self.subarrayBlock){
            self.subarrayBlock(subarray);
        }
        NSPredicate *predicate = [NSPredicate predicateWithFormat:(self.notIn ? @"NOT (%K IN %@)" : @"%K IN %@"), self.key, subarray];
        if(self.andSubpredicates){
            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[self.andSubpredicates arrayByAddingObject:predicate]];
        }
        CKQuery* query = [[CKQuery alloc] initWithRecordType:self.recordType predicate:predicate];
        MHCKFullQueryOperation* op = [[MHCKFullQueryOperation alloc] initWithQuery:query];
        op.recordsFetchedBlock = self.recordsFetchedBlock;
        op.database = self.database;
        [self addOperation:op];
    }
    
    // start the operation
    [super performAsyncOperation];
}

- (void)finishOnCallbackQueueWithError:(NSError*)error{
    if(self.inQueryCompletionBlock){
        self.inQueryCompletionBlock(error);
    }
    [super finishOnCallbackQueueWithError:error];
}

@end
