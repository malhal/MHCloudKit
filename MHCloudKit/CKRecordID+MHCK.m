//
//  CKRecordID+MHCK.m
//  MHCloudKit
//
//  Created by Malcolm Hall on 24/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "CKRecordID+MHCK.h"

@implementation CKRecordID (MHCK)

- (CKReference *)mhck_newReference{
    return [[CKReference alloc] initWithRecordID:self action:CKReferenceActionNone];
}

@end
