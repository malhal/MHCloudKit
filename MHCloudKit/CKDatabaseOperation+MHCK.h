//
//  CKDatabaseOperation+MHCK.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 30/03/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>

@interface CKDatabaseOperation (MHCK)

// by default operations use the private cloud database, this convenience defaults to public.
+ (instancetype)mhck_publicOperation;

@end
