//
//  MHCKFullQueryOperation.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 11/04/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHCKFullQueryOperation.h"
#import "MHCKError.h"

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
    if(!_query){
        *error = [NSError errorWithDomain:MHCloudKitErrorDomain code:CKErrorInvalidArguments userInfo:@{
                                                                                                NSLocalizedDescriptionKey : @"a query must be provided for MHCKFullQueryOperation"
                                                                                                }];
        return NO;
    }
    if(!_database){
        *error = [NSError errorWithDomain:MHCloudKitErrorDomain code:CKErrorInvalidArguments userInfo:@{
                                                                                                NSLocalizedDescriptionKey : @"a database must be provided for MHCKFullQueryOperation"
                                                                                                }];
        return NO;
    }
    return YES;
}

-(void)performAsyncOperation{
    [super performAsyncOperation];
    
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc] initWithQuery:_query];
    
    // a new dictionary will be used for every batch.
    __block NSMutableDictionary* queriedRecordsByRecordID = [NSMutableDictionary dictionary];
    
    // this block adds records to the result array
    void (^recordFetchedBlock)(CKRecord *record) = ^void(CKRecord *record) {
        queriedRecordsByRecordID[record.recordID] = record;
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
        
        [self _recordsFetched:queriedRecordsByRecordID];
        
        // prepare for the next batch
        queriedRecordsByRecordID = [NSMutableDictionary dictionary];
        
        if(cursor){
            //get the next batch.
            CKQueryOperation* cursorOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
            cursorOperation.queryCompletionBlock = strongQueryCompletionBlock;
            cursorOperation.recordFetchedBlock = recordFetchedBlock;
            cursorOperation.database = _database;
            [self addOperation:cursorOperation];
        }
    };
    queryOperation.recordFetchedBlock = recordFetchedBlock;
    queryOperation.queryCompletionBlock = queryCompletionBlock;
    queryOperation.database = self.database;
    [self addOperation:queryOperation];
}

- (void)_finishOnCallbackQueueWithError:(NSError*)error{
    if(_queryCompletionBlock){
        _queryCompletionBlock(error);
    }
    [super _finishOnCallbackQueueWithError:error];
}

-(void)_recordsFetched:(NSDictionary*)recordsByRecordID{
    // allow download to continue while records are being processed.
    [self performBlockOnCallbackQueue:^{
        if(_recordsFetchedBlock){
            _recordsFetchedBlock(recordsByRecordID);
        }
    }];
}

@end
