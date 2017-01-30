//
//  ConnectionHelper.h
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface ConnectionHelper : AFHTTPSessionManager

/**
 * gets singleton object.
 * @return singleton
 */
+ (ConnectionHelper *)sharedClient;

- (void)requestNotasWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                     andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestFaltasWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                      andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestACWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                  andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestCalendarioWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                          andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestHorariosWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                        andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestDesempenhoWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                          andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

#pragma mark - Status Requests

+ (void)requestForTiaStatusWithBlockSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                            andBlockFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock;

- (void)requestForWSStatusWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                           andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)requestForWSPushStatusWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                               andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

/**
 *  Cancelar todas as requests em execução do AFNetworking
 */
- (void)cancelAllRequests;

/**
 *  Inicia o Activity Indicator
 */
+ (void)startActivityIndicator;
/**
 *  Para a animação do Activity indicator
 */
+ (void)stopActivityIndicator;
+ (NSString *)tiaUrlWithTia:(NSString *)tia
                   withPass:(NSString *)pass
                withUnidade:(NSString *)uni
                    andTipo:(NSString *)tipo DEPRECATED_ATTRIBUTE;
/**
 *  Monta uma URL baseado no tipo.
 *
 *  @param tipo Tipo de requests (ver macros tipo)
 *
 *  @return Uma URL em formato @c NSString
 */
+ (NSString *)tiaUrlWithTipo:(NSString *)tipo;

/**
 *  Monta os parametros de login, tendo como dado o @c LoggedUser salvo.
 *
 *  @param tipo Monta o tipo da request.
 *
 *  @return Devolve um dicionario pronto para request no webservice.
 */
+ (NSDictionary *)paramsDictionaryWithTipo:(NSString *)tipo;

/**
 *  Exibe UIAlertView de acordo com a mensagem de erro dada.
 *  
 *  Interrompe o Activity Indicator, e cancela todas as requests.
 *
 *  @param error NSError
 */
- (void)handleConnectionError:(NSError *)error;

@end
