//
//  PFCloud+MackNotas.m
//  MackNotas
//
//  Created by Caio Remedio on 18/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "PFCloud+MackNotas.h"
#import "LocalUser.h"

NSString static *kClassNameInvite   = @"Invite";
NSString static *kClassNameUser     = @"user";

NSString static *kFunctionNameVerifyBeforeSignUp = @"verifyTiaBeforeSignUpWithTiaAndPass";
NSString static *kFunctionNameVerifyPFUserAuth = @"verifyPFUserAuthOnWebService";
NSString static *kFunctionNameEncryptPass = @"encryptPassWithPFUserAtSignUp";
NSString static *kFunctionNameUpdatedRegisteredUser = @"updateRegisteredUserPasswordWithTiaAndPass";
NSString static *kFunctionNameInviteUserToPush = @"inviteUserToPush";

@implementation PFCloud (MackNotas)

#pragma mark - Invites Methods

+ (void)requestUserInvitesWithBlock:(PFObjectResultBlock)block {

    PFQuery *query =[PFQuery queryWithClassName:kClassNameInvite];
    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        return;
    }

    [query whereKey:kClassNameUser equalTo:currentUser];
    [query getFirstObjectInBackgroundWithBlock:block];
}

+ (void)inviteUserToPushWithTia:(NSString *)tia
                       andBlock:(PFIdResultBlock)block {

    [PFCloud callFunctionInBackground:kFunctionNameInviteUserToPush
                       withParameters:@{@"tia" : tia}
                                block:block];
}

#pragma mark - Register/Login methods

+ (void)verifyPFUserAuthWithWebServiceWithBlock:(PFIdResultBlock)block {

    [PFCloud callFunctionInBackground:kFunctionNameVerifyPFUserAuth
                       withParameters:@{}
                                block:block];
}

+ (void)verifyTiaBeforeSignUpWithTIA:(NSString *)userTia
                         andPassword:(NSString *)userPass
                          andUnidade:(NSString *)userUnidade
                        andWithBlock:(PFIdResultBlock)block {

    [PFCloud callFunctionInBackground:kFunctionNameVerifyBeforeSignUp
                       withParameters:@{@"userTia" : userTia,
                                        @"userPass" : userPass,
                                        @"userUnidade" : userUnidade}
                                block:block];
}

+ (void)signUpInBackgroundWithTIA:(NSString *)userTia
                      andPassword:(NSString *)userPass
                       andUnidade:(NSString *)userUnidade
                     andWithBlock:(PFBooleanResultBlock)block {

    PFUser *localUser = [PFUser user];
    localUser.username = userTia;
    localUser.password = userPass;
    localUser[@"showNota"] = @NO;
    localUser[@"pushOnlyOnce"] = @NO;
    localUser[@"hasPush"] = @NO;
    localUser[@"unidade"] = userUnidade;

    [localUser signUpInBackgroundWithBlock:block];
}

+ (void)encryptPassWithPFUserAtSignUpWithPass:(NSString *)userPass {

    [PFCloud callFunctionInBackground:kFunctionNameEncryptPass
                       withParameters:@{@"passToBeEncrypted" : userPass}
                                block:^(NSString *result, NSError *error) {
                                    if (!error) {

                                    }
                                }];
}

+ (void)updateRegisteredUserPasswordWithTia:(NSString *)userTia
                                andPassword:(NSString *)userPass
                                 andUnidade:(NSString *)userUnidade
                               andWithBlock:(PFIdResultBlock)block {

    [PFCloud callFunctionInBackground:kFunctionNameUpdatedRegisteredUser
                       withParameters:@{@"userTia" : userTia,
                                        @"userPass" : userPass,
                                        @"userUnidade" : userUnidade}
                                block:block];
}

@end