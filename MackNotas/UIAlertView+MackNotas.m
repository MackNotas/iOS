//
//  UIAlertView+MackNotas.m
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "UIAlertView+MackNotas.h"

@implementation UIAlertView (MackNotas)

+ (UIAlertView *)alertViewLoginFailed {

    UIAlertView *alertViewLoginFailed = [[UIAlertView alloc]initWithTitle:@"Ops, deu ruim!"
                                                      message:@"Sua senha não confere com o TIA, por favor, logue-se novamente!"
                                                     delegate:nil
                                            cancelButtonTitle:@"Fechar"
                                            otherButtonTitles:nil];

    return alertViewLoginFailed;
}

+ (UIAlertView *)alertViewAllFailedWithException:(NSException *)exception {

    return [self alertViewWithCustomMessage:fstr(@"Algo de estranho aconteceu e não foi culpa sua. Por favor, tente recarregar essa página. \n\nSe isso for constante, reporte esse erro:\n%@",exception.userInfo.description)];
}

+ (UIAlertView *)alertViewTiaErrorWithError:(NSError *)error {

    UIAlertView *alertViewTiaError;

    if ([[error.userInfo allKeys] containsObject:@"NSLocalizedDescription"]) {
        alertViewTiaError = [[UIAlertView alloc]initWithTitle:@"Ops, deu ruim!"
                                                   message:fstr(@"O servidor do TIA provavelmente está offline."
                          "\nPor favor, tente novamente mais tarde!\nSe esse erro for frequente, reporte esta tela de aviso.\n\nMensagem de erro para debug: %@\n%ld", error.userInfo[@"NSLocalizedDescription"], (long)error.code)
                                                  delegate:nil
                                         cancelButtonTitle:@"Fechar"
                                         otherButtonTitles:nil];
    }
    else {
        alertViewTiaError = [[UIAlertView alloc]initWithTitle:@"Ops, deu ruim!"
                                                                   message:fstr(@"O servidor do TIA provavelmente está offline."
                                                                                "\nPor favor, tente novamente mais tarde!\nSe esse erro for frequente, reporte esta tela de aviso.\n\nMensagem de erro para debug: %ld", (long)error.code)
                                                                  delegate:nil
                                                         cancelButtonTitle:@"Fechar"
                                                         otherButtonTitles:nil];
    }

    return alertViewTiaError;
}

+ (UIAlertView *)alertViewSessionError {

    UIAlertView *alertViewSessionError = [[UIAlertView alloc]initWithTitle:@"Ops, deu ruim!"
                                                       message:@"Algo não está certo. Por favor, logue-se novamente."
                                                      delegate:nil
                                             cancelButtonTitle:@"Fechar"
                                             otherButtonTitles:nil];

    return alertViewSessionError;
}

+ (UIAlertView *)alertViewTiaFailedWS {

    UIAlertView *alertViewTiaFailedWS = [[UIAlertView alloc] initWithTitle:@"Ops, deu ruim!"
                                                       message:@"Seu TIA/senha estão incorretos.\nPor favor tente novamente."
                                                      delegate:nil
                                             cancelButtonTitle:@"Fechar"
                                             otherButtonTitles:nil];

    return alertViewTiaFailedWS;
}

+ (UIAlertView *)alertViewAllFailedWithError:(NSError *)error {

    UIAlertView *alertViewAllFailed = [[UIAlertView alloc] initWithTitle:@"Ops, deu ruim. Mas muito ruim!"
                                                     message:fstr(@"Algo não está certo aqui. Por favor, "
                           "verifique sua conexão com a internet e tente novamente mais tarde.\n Se esse erro for frequente, reporte esta tela de aviso.\n\nMensagem de erro para debug:\n%@ %ld",  error.userInfo[@"NSLocalizedDescription"], (long)error.code)
                                                    delegate:nil
                                           cancelButtonTitle:@"Fechar"
                                           otherButtonTitles:nil];
    
    return alertViewAllFailed;
}

+ (UIAlertView *)alertViewWSOffline:(NSError *)error {

    UIAlertView *alertViewAllFailed = [[UIAlertView alloc] initWithTitle:@"Ops, deu ruim!"
                                                                 message:fstr(@"Nossos servidores provavelmente estão offline ou sobrecarregados.\n"
                                                                              "Por favor, tente novamente mais tarde.\n Se esse erro for frequente, reporte esta tela de aviso.\n\nMensagem de erro para debug:\n%@ %ld",  error.userInfo[@"NSLocalizedDescription"], (long)error.code)
                                                                delegate:nil
                                                       cancelButtonTitle:@"Fechar"
                                                       otherButtonTitles:nil];
    
    return alertViewAllFailed;
}

+ (UIAlertView *)alertViewNotasError:(NSError *)error {

    UIAlertView *alertViewNotasError = [[UIAlertView alloc] initWithTitle:@"Ops, deu ruim!"
                                                                    message:fstr(@"Algo não está certo aqui. Por favor, "
                                                                                 "verifique sua conexão com a internet e tente novamente mais tarde.\n Se esse erro for frequente, reporte esta tela de aviso.\n\nMensagem de erro para debug:\n%@ %ld", error.userInfo[@"NSLocalizedDescription"], (long)error.code)
                                                                delegate:nil
                                                       cancelButtonTitle:@"Fechar"
                                                       otherButtonTitles:nil];

    return alertViewNotasError;
}

+ (UIAlertView *)alertViewNoInternet {

    UIAlertView *alertViewNoInternet = [[UIAlertView alloc] initWithTitle:@"Ops, deu ruim!"
                                                                 message:@"Parece que há algum problema com a sua conexão à internet.\nPor favor, verifique sua conexão e tente novamente."
                                                                delegate:nil
                                                       cancelButtonTitle:@"Fechar"
                                                       otherButtonTitles:nil];

    return alertViewNoInternet;
}

+ (UIAlertView *)alertViewWithCustomMessage:(NSString *)msg {

    return [self alertViewWithCustomTitle:@"Ops, deu ruim!"
                               andMessage:msg];
}

+ (UIAlertView *)alertViewWithCustomTitle:(NSString *)title andMessage:(NSString *)msg {

    UIAlertView *alertViewNoInternet = [[UIAlertView alloc] initWithTitle:title
                                                                  message:msg
                                                                 delegate:nil
                                                        cancelButtonTitle:@"Fechar"
                                                        otherButtonTitles:nil];

    return alertViewNoInternet;
}

+ (UIAlertView *)alertViewWithParseError:(NSError *)parseError {

    return [self alertViewWithCustomMessage:parseError.userInfo[@"error"]];
}

#pragma mark - UIAlertView With TextFields

+ (UIAlertView *)alertViewWithTextInputTitle:(NSString *)title message:(NSString *)message {

    UIAlertView *alertViewTxtInput = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Fechar"
                                                      otherButtonTitles:@"Enviar!", nil];
    alertViewTxtInput.alertViewStyle = UIAlertViewStylePlainTextInput;

    return alertViewTxtInput;
}

@end
