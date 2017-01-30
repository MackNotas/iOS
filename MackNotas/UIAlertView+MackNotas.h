//
//  UIAlertView+MackNotas.h
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (MackNotas)
/**
 *  Senha do usuário está errada, mas ele já está logado.
 *
 */
+ (UIAlertView *)alertViewLoginFailed;
/**
 *  Servidor do TIA esta offline (mostra mensagem de erro para debug)
 *
 */
+ (UIAlertView *)alertViewTiaErrorWithError:(NSError *)error;
/**
 *  Erro de sessão.
 *
 */
+ (UIAlertView *)alertViewSessionError;
/**
 *  Usuário faz login, e a senha está errada.
 *
 */
+ (UIAlertView *)alertViewTiaFailedWS;
/**
 *  Erro genérico para os demais casos.
 *
 */
+ (UIAlertView *)alertViewAllFailedWithError:(NSError *)error;
/**
 *  Webservice está offline/erro interno etc...
 *
 */
+ (UIAlertView *)alertViewWSOffline:(NSError *)error;
/**
 *  Quando a internet do usuário está com problemas (Offline provavel)
 */
+ (UIAlertView *)alertViewNoInternet;

/**
 *  Erro especial para a nota (para não mostrar a URL do WS)
 *
 */
+ (UIAlertView *)alertViewNotasError:(NSError *)error;

/**
 *  Erro genérico com uma mensagem customizada.
 *
 *  @param msg Mensagem para ser aparecida no alerta.
 */
+ (UIAlertView *)alertViewWithCustomMessage:(NSString *)msg;

+ (UIAlertView *)alertViewWithCustomTitle:(NSString *)title andMessage:(NSString *)msg;

/**
 *  Erro com uma mensagem pré definida no servidor do Parse
 *
 *  @param parseMsg Mensagem do Parse
 *
 */
+ (UIAlertView *)alertViewWithParseError:(NSError *)parseError;

/**
 *  Envie um @c NSException para ser mostrado o @c userInfos ao usuário.
 *
 *  @param exception Uma @c NSException gerada.
 */
+ (UIAlertView *)alertViewAllFailedWithException:(NSException *)exception;

#pragma mark - UIAlertView With TextFields

+ (UIAlertView *)alertViewWithTextInputTitle:(NSString *)title message:(NSString *)message;

@end
