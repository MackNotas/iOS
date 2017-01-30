//
//  LocalUser.m
//  MackNotas
//
//  Created by Caio Remedio on 17/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "LocalUser.h"
#import "DBManager.h"
#import "SettingsViewController.h"

typedef enum : NSUInteger {
    differentCursoEM = 1,
    differentCursoPos,
    differentCursoArq,
    differentCursoDesign
} differentCurso;

@implementation LocalUser

static LocalUser *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[LocalUser alloc] init];
}

- (id)mutableCopy
{
    return [[LocalUser alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    
    return self;
}

#pragma mark - NSCoding Protocols

- (id)initWithCoder:(NSCoder *)aDecoder {

    if (self) {
        self.tia            = [aDecoder decodeObjectForKey:@"tia"];
        self.senha          = [aDecoder decodeObjectForKey:@"senha"];
        self.unidade        = [aDecoder decodeObjectForKey:@"unidade"];
        self.nomeCompleto   = [aDecoder decodeObjectForKey:@"nomeCompleto"];
        self.curso          = [aDecoder decodeObjectForKey:@"curso"];
        self.shouldBlockNotas= [aDecoder decodeObjectForKey:@"shouldBlockNotas"];
        self.differentCurso = [aDecoder decodeObjectForKey:@"differentCurso"];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.tia forKey:@"tia"];
    [aCoder encodeObject:self.senha forKey:@"senha"];
    [aCoder encodeObject:self.unidade forKey:@"unidade"];
    [aCoder encodeObject:self.nomeCompleto forKey:@"nomeCompleto"];
    [aCoder encodeObject:self.curso forKey:@"curso"];
    [aCoder encodeObject:self.shouldBlockNotas forKey:@"shouldBlockNotas"];
    [aCoder encodeObject:self.differentCurso forKey:@"differentCurso"];
}

#pragma mark - Properties Override

- (BOOL)hasPush {

    PFUser *user = [PFUser currentUser];

    return [user[@"hasPush"] boolValue];
}

- (BOOL)isEnsinoMedio {

    return [self.differentCurso isEqualToNumber:@(differentCursoEM)];
}

#pragma mark - Public Methods

+ (void)clearAllData {

    [DBManager clearAllData];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LAST_UPDATE_NOTAS];
    [defaults removeObjectForKey:LAST_UPDATE_HORARIO];
    [defaults removeObjectForKey:LAST_UPDATE_AC];
    [defaults removeObjectForKey:LAST_UPDATE_FALTAS];
    [defaults removeObjectForKey:LAST_UPDATE_CALENDARIO];
    [defaults removeObjectForKey:SETTINGS_IS_EM];
    
    [defaults synchronize];
}

- (void)loadUserTia:(NSString *)tia
              senha:(NSString *)senha
            unidade:(NSString *)unidade
     serverResponse:(NSDictionary *)response {

    self.tia = tia;
    self.senha = senha;
    self.unidade = unidade;

    //
    // Resposta de infos do usuario do WS
    //
    self.nomeCompleto = response[@"nomeCompleto"];
    self.curso = response[@"curso"];
    self.shouldBlockNotas = response[@"shouldBlockNotas"];
    self.differentCurso = [NSNumber numberWithInteger:[response[@"differentCurso"] integerValue]];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:self.isEnsinoMedio]
                                              forKey:SETTINGS_IS_EM];
}

+ (void)logout {

    [PFUser logOut];
    [self clearAllData];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSettingsViewControllerWillLogoutUserNotification
                                                        object:self];
}

@end