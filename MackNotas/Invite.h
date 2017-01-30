//
//  Invite.h
//  MackNotas
//
//  Created by Caio Remedio on 27/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Parse/Parse.h>

@interface Invite : PFObject <PFSubclassing>

@property (nonatomic) BOOL hasInvites;
@property (nonatomic) BOOL hasInvitedAnyone;
@property (nonatomic) NSInteger numberOfInvitedUsers;

@property (nonatomic, readonly) NSInteger numberOfInvitesAvailable;

/**
 *  Retorna o TIA do usuário que foi convidado.
 *  NIL quando não há nenhum usuário.
 *
 *  @param indexPath NSIndexPath da cell
 *
 *  @return O TIA do usuário, ou NIL caso não há.
 */
- (NSString *)invitedUserForIndexPath:(NSIndexPath *)indexPath;

@end
