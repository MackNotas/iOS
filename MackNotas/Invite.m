//
//  Invite.m
//  MackNotas
//
//  Created by Caio Remedio on 27/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "Invite.h"

@interface Invite ()

@property (nonatomic) PFUser *user;
@property (nonatomic) NSNumber *invitesDisponiveis;
@property (nonatomic) NSArray *usersInvited;

@end

@implementation Invite

@dynamic user;
@dynamic invitesDisponiveis;
@dynamic usersInvited;

@synthesize hasInvites;
@synthesize numberOfInvitedUsers;
@synthesize hasInvitedAnyone;

+ (void)load {

    [self registerSubclass];
}

+ (NSString * __nonnull)parseClassName {

    return NSStringFromClass([Invite class]);
}

#pragma mark - Properties Override

- (BOOL)hasInvites {

    return self.invitesDisponiveis.intValue > 0;
}

- (NSInteger)numberOfInvitedUsers {

    return self.usersInvited.count;
}

- (BOOL)hasInvitedAnyone {

    return self.numberOfInvitedUsers > 0;
}

- (NSInteger)numberOfInvitesAvailable {

    return self.invitesDisponiveis.integerValue;
}

#pragma mark - Public Methods

- (NSString *)invitedUserForIndexPath:(NSIndexPath *)indexPath {

    NSInteger row = indexPath.row;

    if (!self.hasInvitedAnyone) {
        return @"Você ainda não convidou ninguém :(";
    }

    return self.usersInvited[row];
}

@end
