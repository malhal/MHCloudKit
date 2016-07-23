//
//  CKDatabaseOperation+MHCK.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 30/03/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "CKDatabaseOperation+MHCK.h"

@implementation CKDatabaseOperation (MHCK)

+ (instancetype)mhck_publicOperation{
    CKDatabaseOperation* op = [[[self class] alloc] init];
    op.database = [CKContainer defaultContainer].publicCloudDatabase;
    return op;
}

@end
