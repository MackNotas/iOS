//
//  DBManager.h
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <YapDatabase/YapDatabase.h>
#import <YapDatabase/YapDatabaseConnection.h>
#import <YapDatabase/YapDatabaseView.h>
#import <YapDatabase/YapDatabaseFilteredView.h>

FOUNDATION_EXPORT NSString * const DBManagerWillUpdateNotification;
FOUNDATION_EXPORT NSString * const DBManagerDidUpdateNotification;

@protocol Persistable <NSObject>

- (NSString *)key;

+ (NSString *)collectionKey;

@optional
+ (void)registerViewsInDatabase:(YapDatabase *)database;

@end

@interface DBManager : NSObject

@property (nonatomic, readonly) YapDatabase *database;

@property (nonatomic, readonly) YapDatabaseConnection *uiConnection;
@property (nonatomic, readonly) YapDatabaseConnection *rwConnection;

/**
 * gets singleton object.
 * @return singleton
 */
+ (DBManager*)sharedInstance;

+ (void)clearAllData;

/**
 *  Verifica se há necessidade de uma request para atualizar a base local.
 *  É verificado a quantidade de items locais e o tempo desde a última atualização, respeitando o tempo estipulado de cache de cada model.
 *
 *  @param model    As subclasses @c MNModel
 *  @param mappings O mappings utilizado em cada tela
 *
 *  @return @c YES se precisar, @c NO caso não.
 */
+ (BOOL)shouldUpdateModel:(NSString *)modelClass
             withMappings:(YapDatabaseViewMappings *)mappings;

@end
