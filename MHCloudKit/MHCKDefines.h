//
//  MHCKDefines.h
//  MHCloudKit
//
//  Created by Malcolm Hall on 24/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#ifndef MHCLOUDKIT_EXTERN
    #ifdef __cplusplus
        #define MHCLOUDKIT_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MHCLOUDKIT_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif