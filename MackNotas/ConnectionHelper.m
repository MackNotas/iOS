//
//  ConnectionHelper.m
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "ConnectionHelper.h"
#import "LocalUser.h"

@interface ConnectionHelper ()

@end

@implementation ConnectionHelper

static ConnectionHelper *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (ConnectionHelper *)sharedClient {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[self alloc]
                     initWithBaseURL:[NSURL URLWithString:URL_WEBSERVICE]];
    });

    return SINGLETON;
}

#pragma mark - Life Cycle

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

- (instancetype)initWithBaseURL:(NSURL *)url {

    self = [super initWithBaseURL:url];

    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.requestSerializer.timeoutInterval = DEFAULT_TIME_OUT_HTTP;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Contenttype"];
        self.responseSerializer = [AFJSONResponseSerializer
                                   serializerWithReadingOptions:NSJSONReadingMutableContainers];

    }

    return self;
}

#pragma mark - Methods Overrided

#pragma mark - JSON Requests

- (void)requestNotasWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                     andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoNota];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoNota];

    DDLogInfo(@"Chamando URL Nota WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           [[ConnectionHelper sharedClient] handleConnectionError:error];

           dispatch_async(dispatch_get_main_queue(), ^{
               if (failureBlock) {
                   failureBlock(task, error);
               }
           });
       }];

    [ConnectionHelper startActivityIndicator];
}

- (void)requestFaltasWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                      andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoFaltas];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoFaltas];

    DDLogInfo(@"Chamando URL Falta WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:^(NSURLSessionDataTask *task, NSError *error) {

           [[ConnectionHelper sharedClient] handleConnectionError:error];

           dispatch_async(dispatch_get_main_queue(), ^{
               if (failureBlock) {
                   failureBlock(task, error);
               }
           });
       }];

    [ConnectionHelper startActivityIndicator];
}

- (void)requestACWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                  andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoAC];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoAC];

    DDLogInfo(@"Chamando URL AC WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:^(NSURLSessionDataTask *task, NSError *error) {

           [[ConnectionHelper sharedClient] handleConnectionError:error];

           dispatch_async(dispatch_get_main_queue(), ^{
               if (failureBlock) {
                   failureBlock(task, error);
               }
           });
       }];

    [ConnectionHelper startActivityIndicator];
}

- (void)requestCalendarioWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                          andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoCal];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoCal];

    DDLogInfo(@"Chamando URL CAL WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:^(NSURLSessionDataTask *task, NSError *error) {

           [[ConnectionHelper sharedClient] handleConnectionError:error];

           dispatch_async(dispatch_get_main_queue(), ^{
               if (failureBlock) {
                   failureBlock(task, error);
               }
           });
       }];
    [ConnectionHelper startActivityIndicator];
}

- (void)requestHorariosWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                        andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoHorario];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoHorario];

    DDLogInfo(@"Chamando URL HORARIO WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:failureBlock];
    
    [ConnectionHelper startActivityIndicator];
}

- (void)requestDesempenhoWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                        andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    NSString *tiaWS_URL = [ConnectionHelper tiaUrlWithTipo:WebserviceTipoDesempenho];
    NSDictionary *params = [ConnectionHelper paramsDictionaryWithTipo:WebserviceTipoDesempenho];

    DDLogInfo(@"Chamando URL DESEMPENHO WS:\n%@\n%@",tiaWS_URL, params);

    [self POST:tiaWS_URL
    parameters:params
       success:successBlock
       failure:failureBlock];

    [ConnectionHelper startActivityIndicator];
}

#pragma mark - Status Requests

+ (void)requestForTiaStatusWithBlockSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                            andBlockFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = DEFAULT_TIME_OUT_HTTP;

    DDLogVerbose(@"Verificando TIA Status");
    [manager GET:URL_TIA parameters:nil success:successBlock failure:failureBlock];
}

- (void)requestForWSStatusWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                            andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    DDLogVerbose(@"Verificando WS Status");
    [self GET:URL_WEBSERVICE parameters:nil success:successBlock failure:failureBlock];
}

- (void)requestForWSPushStatusWithBlockSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))successBlock
                           andBlockFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {

    DDLogVerbose(@"Verificando WSPush Status");
    [self GET:URL_PUSHWEBSERVICE parameters:nil success:successBlock failure:failureBlock];
}

#pragma mark - Reachability



#pragma mark - Other Methods

- (void)cancelAllRequests {

    for (NSURLSessionTask *task in self.tasks) {
        DDLogVerbose(@"Request cancelada: \n%@", task.currentRequest);
        [task cancel];
    }
}

+ (void)startActivityIndicator {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)stopActivityIndicator {

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)handleConnectionError:(NSError *)error {

    [ConnectionHelper stopActivityIndicator];
    [[ConnectionHelper sharedClient] cancelAllRequests];

    DDLogError(@"ConnectionError: %@ %ld", error, (long)error.code);

    if (error.code == CONNECTION_ERROR_TIA_OFFLINE) {
        [[UIAlertView alertViewTiaErrorWithError:error] show];
    }
    else if (error.code == CONNECTION_ERROR_WS_OFFLINE) {
        [[UIAlertView alertViewWSOffline:error] show];
    }
    else if (error.code == CONNECTION_ERROR_NO_INTERNET) {
        [[UIAlertView alertViewNoInternet] show];
    }
    else if (error.code != CONNECTION_ERROR_CANCELED) {
        [[UIAlertView alertViewNotasError:error] show];
    }
}

#pragma mark - Params and URL methods

+ (NSDictionary *)paramsDictionaryWithTipo:(NSString *)tipo {

    LocalUser *localUser = [LocalUser sharedInstance];

    return @{@"userTia"     :   localUser.tia,
             @"userPass"    :   localUser.senha,
             @"userUnidade" :   localUser.unidade,
             @"tipo"        :   tipo};

}

+ (NSString *)tiaUrlWithTipo:(NSString *)tipo {

    return URL_WEBSERVICE;
}

/*
    Deprecated - Só usavel com GET
 */
+ (NSString *)tiaUrlWithTia:(NSString *)tia
                   withPass:(NSString *)pass
                withUnidade:(NSString *)uni
                    andTipo:(NSString *)tipo DEPRECATED_ATTRIBUTE {

    return fstr(@"%@userTia=%@&userPass=%@&userUnidade=%@&tipo=%@",
                URL_WEBSERVICE, tia, pass, uni, tipo);
}

@end
