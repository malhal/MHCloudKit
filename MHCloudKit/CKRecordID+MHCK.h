//
//  CKRecordID+MHCK.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 24/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CloudKit/CloudKit.h>

@interface CKRecordID (MHCK)

- (CKReference *)mhck_newReference;

@end
