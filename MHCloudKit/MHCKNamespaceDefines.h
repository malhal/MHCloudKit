//
//  MHCKNamespaceDefines.h
//  MHCloudKit
//
//  Generated using MHNamespaceGenerator on 04/08/2016
//

#if !defined(__MHCLOUDKIT_NS_SYMBOL) && defined(MHCLOUDKIT_NAMESPACE)
    #define __MHCLOUDKIT_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __MHCLOUDKIT_NS_BRIDGE(ns, symbol) __MHCLOUDKIT_NS_REWRITE(ns, symbol)
    #define __MHCLOUDKIT_NS_SYMBOL(symbol) __MHCLOUDKIT_NS_BRIDGE(MHCLOUDKIT_NAMESPACE, symbol)
// Classes
    #define MHCKFullQueryOperation __MHCLOUDKIT_NS_SYMBOL(MHCKFullQueryOperation)
    #define MHCKQueryRecordsOperation __MHCLOUDKIT_NS_SYMBOL(MHCKQueryRecordsOperation)
// Categories
    #define mhck_performCursoredQuery __MHCLOUDKIT_NS_SYMBOL(mhck_performCursoredQuery)
    #define mhck_publicOperation __MHCLOUDKIT_NS_SYMBOL(mhck_publicOperation)
    #define mhck_reference __MHCLOUDKIT_NS_SYMBOL(mhck_reference)
    #define mhck_saveRecords __MHCLOUDKIT_NS_SYMBOL(mhck_saveRecords)
// Externs
    #define MHCloudKitErrorDomain __MHCLOUDKIT_NS_SYMBOL(MHCloudKitErrorDomain)
    #define MHCloudKitVersionNumber __MHCLOUDKIT_NS_SYMBOL(MHCloudKitVersionNumber)
    #define MHCloudKitVersionString __MHCLOUDKIT_NS_SYMBOL(MHCloudKitVersionString)
#endif
