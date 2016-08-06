//
//  MHCKFullQueryOperation.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 11/04/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHCKFullQueryOperation.h"
#import "MHCKError.h"
#import "NSError+MHF.h"

@implementation MHCKFullQueryOperation

- (instancetype)initWithQuery:(CKQuery *)query
{
    self = [super init];
    if (self) {
        _query = query.copy;
    }
    return self;
}

-(BOOL)asyncOperationShouldRun:(NSError *__autoreleasing *)error{
    // todo check if these should be consistency exceptions.
    if(!self.query){
        *error = [NSError mhf_errorWithDomain:CKErrorDomain code:CKErrorInvalidArguments descriptionFormat:@"a query must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    else if(!self.database){
        *error = [NSError mhf_errorWithDomain:CKErrorDomain code:CKErrorInvalidArguments descriptionFormat:@"a database must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    return [super asyncOperationShouldRun:error];
}

-(void)performAsyncOperation{
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc] initWithQuery:self.query];
    
    // a new dictionary will be used for every batch.
    __block NSMutableArray* queriedRecords = [NSMutableArray array];
    
    // this block adds records to the result array
    void (^recordFetchedBlock)(CKRecord *record) = ^void(CKRecord *record) {
        [queriedRecords addObject:record];
    };
    
    //this is used to allow the block to call itself recursively without causing a retain cycle.
    void (^queryCompletionBlock)(CKQueryCursor * cursor, NSError * operationError);
    __block __weak typeof(queryCompletionBlock) weakQueryCompletionBlock;
    
    weakQueryCompletionBlock = queryCompletionBlock = ^void(CKQueryCursor * cursor, NSError * operationError) {
        void (^strongQueryCompletionBlock)() = weakQueryCompletionBlock;
        if(operationError){
            if(operationError.code == CKErrorOperationCancelled){
                return;
            }
            [self finishWithError:operationError];
            return;
        }
        
        if(queriedRecords.count){
            [self recordsFetched:queriedRecords];
        }
        
        // prepare for the next batch
        queriedRecords = [NSMutableArray array];
        
        if(cursor){
            //get the next batch.
            CKQueryOperation* cursorOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
            cursorOperation.queryCompletionBlock = strongQueryCompletionBlock;
            cursorOperation.recordFetchedBlock = recordFetchedBlock;
            cursorOperation.database = self.database;
            [self addOperation:cursorOperation];
        }
    };
    queryOperation.recordFetchedBlock = recordFetchedBlock;
    queryOperation.queryCompletionBlock = queryCompletionBlock;
    queryOperation.database = self.database;
    [self addOperation:queryOperation];
    
    // start the operation
    [super performAsyncOperation];
}

- (void)finishOnCallbackQueueWithError:(NSError*)error{
    if(self.queryCompletionBlock){
        self.queryCompletionBlock(error);
    }
    [super finishOnCallbackQueueWithError:error];
}

-(void)recordsFetched:(NSArray*)records{
    // allow download to continue while records are being processed, according to CloudKit docs thats what we are supposed to do.
    [self performBlockOnCallbackQueue:^{
        if(self.recordsFetchedBlock){
            self.recordsFetchedBlock(records);
        }
    }];
}

@end
