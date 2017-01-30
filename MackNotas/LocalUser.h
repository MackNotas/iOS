//
//  LocalUser.h
//  MackNotas
//
//  Created by Caio Remedio on 17/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

@interface LocalUser : NSObject <NSCoding>

/**
 * gets singleton object.
 * @return singleton
 */
+ (LocalUser*)sharedInstance;

@property NSString *tia;
@property NSString *senha;
@property NSString *unidade;
@property NSNumber *shouldBlockNotas;

@property NSString *nomeCompleto;
@property NSString *curso;
@property NSNumber *differentCurso;

@property (nonatomic) BOOL hasPush;
@property (nonatomic, readonly) BOOL isEnsinoMedio;

- (void)loadUserTia:(NSString *)tia
              senha:(NSString *)senha
            unidade:(NSString *)unidade
     serverResponse:(NSDictionary *)response;
/**
 *  Logout the current PFUser and clear all YapDatabase data from the device.
 */
+ (void)logout;

+ (void)clearAllData;

@end
