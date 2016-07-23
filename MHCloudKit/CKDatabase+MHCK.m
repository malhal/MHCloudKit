//
//  CKDatabase+MHCK.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 10/08/2014.
//  Copyright (c) 2014 Malcolm Hall. All rights reserved.
//

#import "CKDatabase+MHCK.h"

@implementation CKDatabase (MHCK)

- (void)mhck_saveRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSError *error))completionHandler{
    CKModifyRecordsOperation* modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
    [modifyRecordsOperation setModifyRecordsCompletionBlock:^(NSArray *savedRecords, NSArray *deletedRecords, NSError *error) {
        completionHandler(savedRecords,error);
    }];
    [self addOperation:modifyRecordsOperation];
}

- (void)mhck_performCursoredQuery:(CKQuery *)query cursorResultsLimit:(int)cursorResultsLimit inZoneWithID:(CKRecordZoneID *)zoneID completionHandler:(void (^)(NSArray<CKRecord *> *results, NSError *error))completionHandler{
    
    //holds all the records received.
    NSMutableArray* records = [NSMutableArray array];
    
    //this block adds records to the result array
    void (^recordFetchedBlock)(CKRecord *record) = ^void(CKRecord *record) {
        [records addObject:record];
    };
    
    //this is used to allow the block to call itself recurively without causing a retain cycle.
    
    void (^queryCompletionBlock)(CKQueryCursor *cursor, NSError *error);
    __block __weak typeof(queryCompletionBlock) weakQueryCompletionBlock;
    
    weakQueryCompletionBlock = queryCompletionBlock = ^void(CKQueryCursor *cursor, NSError *error) {
        //typeof (queryCompletionBlock) q = queryCompletionBlock;
        NSLog(@"rec count %ld", (unsigned long)records.count);
        //if any error at all then end with no results. Note its possible that we got some results, and even might have got a cursor. However if there is an error then the cursor doesn't work properly so will just return with no results.
        if(error){
            completionHandler(nil,error);
        }
        else if(cursor){
            CKQueryOperation* cursorOperation = [[CKQueryOperation alloc] initWithCursor:cursor];
            cursorOperation.resultsLimit = cursorResultsLimit;
            cursorOperation.zoneID = zoneID;
            cursorOperation.recordFetchedBlock = recordFetchedBlock;
            cursorOperation.queryCompletionBlock = weakQueryCompletionBlock; // use the weak pointer to prevent retain cycle
            //start the recursive operation and return.
            [self addOperation:cursorOperation];
        }
        else{
            completionHandler(records,nil);
        }
    };
    
    //start the initial operation.
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc] initWithQuery:query];
    queryOperation.resultsLimit = cursorResultsLimit;
    queryOperation.zoneID = zoneID;
    queryOperation.recordFetchedBlock = recordFetchedBlock;
    queryOperation.queryCompletionBlock = queryCompletionBlock;
    [self addOperation:queryOperation];
}

/*
- (void)mhck_fetchAllSubscriptionsByIDWithCompletionHandler:(void (^)(NSDictionary <NSString *, CKSubscription *> * __nullable subscriptionsBySubscriptionID, NSError * __nullable error))completionHandler{
    CKFetchSubscriptionsOperation* op = [CKFetchSubscriptionsOperation fetchAllSubscriptionsOperation];
    op.fetchSubscriptionCompletionBlock = completionHandler;
    [self addOperation:op];
}

-(void)mhck_deleteAllSubscriptionsWithCompletionHandler:(void (^)(NSError * __nullable error))completionHandler{
    [self mhck_fetchAllSubscriptionsByIDWithCompletionHandler:^(NSDictionary<NSString *,CKSubscription *> * _Nullable subscriptionsBySubscriptionID, NSError * _Nullable error) {
        // end if got an error or there are no subscriptions.
        if(error || !subscriptionsBySubscriptionID.count){
            completionHandler(error);
            return;
        }
        CKModifySubscriptionsOperation* op = [[CKModifySubscriptionsOperation alloc] initWithSubscriptionsToSave:nil subscriptionIDsToDelete:subscriptionsBySubscriptionID.allKeys];
        [op setModifySubscriptionsCompletionBlock:^(NSArray<CKSubscription *> * _Nullable savedSubscriptions, NSArray<NSString *> * _Nullable deletedSubscriptionIDs, NSError * _Nullable error) {
            completionHandler(error);
        }];
        [self addOperation:op];
    }];
}
*/

@end
