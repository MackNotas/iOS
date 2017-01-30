//
//  PFCloud+MackNotas.h
//  MackNotas
//
//  Created by Caio Remedio on 18/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Parse/Parse.h>

@interface PFCloud (MackNotas)
/**
 *  Funcao de verificar se o a senha do usuário cadastrada no parse é válida no TIA do mackenzie
 *  @Recebe como parametro apenas o PFUser, que espera-se que já contenha uma senha encriptada salva
 *  @Retorna o JSON fornecido pelo WS (Login: true, false)
 *
 *  @param block
 */
+ (void)verifyPFUserAuthWithWebServiceWithBlock:(PFIdResultBlock)block;
/**
 *  Função de verificar se o TIA é valido no site do mackenzie, antes de se registrar no Parse
 *
 *  @param userTia  TIA
 *  @param userPass Senha crua
 *  @param block    resp
 */
+ (void)verifyTiaBeforeSignUpWithTIA:(NSString *)userTia
                         andPassword:(NSString *)userPass
                          andUnidade:(NSString *)userUnidade
                        andWithBlock:(PFIdResultBlock)block;

/**
 *  Método de SignUp sobrescrito
 *
 *  @param userTia  TIA
 *  @param userPass Senha Crua
 *  @param block    resp
 */
+ (void)signUpInBackgroundWithTIA:(NSString *)userTia
                      andPassword:(NSString *)userPass
                       andUnidade:(NSString *)userUnidade
                     andWithBlock:(PFBooleanResultBlock)block;

/**
 *  Encripta a senha do usuário e a salva no Parse na coluna passwordEnc
 *
 *  @param userPass Senha Crua
 */
+ (void)encryptPassWithPFUserAtSignUpWithPass:(NSString *)userPass;

/**
 *  Quando o usuário alterou a senha no TIA, atualiza ela no Parse.
 *
 *  @param userTia  TIA
 *  @param userPass Senha crua
 *  @param block    resp
 */
+ (void)updateRegisteredUserPasswordWithTia:(NSString *)userTia
                                andPassword:(NSString *)userPass
                                 andUnidade:(NSString *)userUnidade
                               andWithBlock:(PFIdResultBlock)block;

/**
 *  Obtem informações sobre invites disponíveis do usuário atualmente conectado
 *
 *  @param block Response.
 */
+ (void)requestUserInvitesWithBlock:(PFObjectResultBlock)block;

/**
 *  Chama a lógica para convidar alguem em background.
 *
 *  @param tia   TIA do usuário a ser convidado
 *  @param block Response se o envite foi enviado com sucesso.
 */
+ (void)inviteUserToPushWithTia:(NSString *)tia
                       andBlock:(PFIdResultBlock)block;

@end
