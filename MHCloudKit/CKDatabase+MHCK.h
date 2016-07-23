//
//  CKDatabase+MHCK.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 10/08/2014.
//  Copyright (c) 2014 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CKDatabase (MHCK)

/* Convenience method for creating multiple records. */
/* Must be max 400 records */
- (void)mhck_saveRecords:(NSArray<CKRecord *> *)records completionHandler:(void (^)(NSArray<CKRecord *> *savedRecords, NSError *error))completionHandler;

/* Convenience method for performing a query receiving the results in batches using multiple network calls. Best use max 400 for cursorResultsLimit otherwise server sometimes exceptions telling you to use max 400. Even using CKQueryOperationMaximumResults can cause this exception.  */
- (void)mhck_performCursoredQuery:(CKQuery *)query cursorResultsLimit:(int)cursorResultsLimit inZoneWithID:(CKRecordZoneID *)zoneID completionHandler:(void (^)(NSArray<CKRecord *> *results, NSError *error))completionHandler;

/* Convenience method for fetching all subscriptions in a dictionary by IDs rather than an array */
//- (void)mhck_fetchAllSubscriptionsByIDWithCompletionHandler:(void (^)(NSDictionary <NSString *, CKSubscription *> * __nullable subscriptionsBySubscriptionID, NSError * __nullable error))completionHandler;

/* Convenience for two-step operation of querying for all subscriptions and then deleting them */
//-(void)mhck_deleteAllSubscriptionsWithCompletionHandler:(void (^)(NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END