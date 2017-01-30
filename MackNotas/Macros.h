//
//  Macros.h
//  Mack Notas
//
//  Created by Caio Remedio on 12/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

static NSString *const kDefaultsCurrentVersion = @"current_version";

/**
 *  WebService URLs
 */
static NSString *const URL_WEBSERVICE =     @"https://tia-webservice.herokuapp.com/tiaLogin_v3.php";
//static NSString *const URL_WEBSERVICE =     @"http://tia-webservice.herokuapp.com/jsonTeste.php?";
//static NSString *const URL_WEBSERVICE =     @"http://tiulocal.noip.me/mack/tia-webservice/tiaLogin_v3.php";
//static NSString *const URL_WEBSERVICE =     @"http://tiulocal.noip.me/tiaLogin_v3.php";
//static NSString *const URL_WEBSERVICE =     @"http://192.168.0.100/mack/tia-webservice/tiaLogin.php?";

/**
 *  Other URLs
 */
static NSString *const URL_PUSHWEBSERVICE = @"https://tia-pushwebservice.herokuapp.com/tiaLogin.php?";
static NSString *const URL_TIA            = @"https://www3.mackenzie.com.br/tia/index.php";
static NSString *const URL_TWITTER        = @"https://www.facebook.com/MackNotas";

/**
 *  Parse
 */

static NSString * const PARSE_APPID = @"KEY";
static NSString * const PARSE_CLIENTID = @"KEY";


@interface Macros


/**
 *  FilePath
 */

#define DATA_FILE_NAME  @"jj0293hggws23.3re"
#define DATA_DATABASE_FILE  @"macknotas.sqlite"

#define FACEBOOK_PAGE_ID @"641625832641666"

/**
 *  Macros
 */
#define fstr(format, ...) [NSString stringWithFormat:format, __VA_ARGS__]
#define SYSTEM_VERSION_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) \
([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define SCREEN_IS_4_INCHES   SCREEN_WIDTH == 320.0f && SCREEN_HEIGHT == 568.0f
#define SCREEN_IS_3_5_INCHES SCREEN_WIDTH == 320.0f && SCREEN_HEIGHT == 480.0f
#define SCREEN_IS_4_7_INCHES SCREEN_WIDTH == 375.0f && SCREEN_HEIGHT == 667.0f
#define SCREEN_IS_5_5_INCHES SCREEN_WIDTH == 414.0f && SCREEN_HEIGHT == 736.0f

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE   [UIScreen mainScreen].bounds.size

/**
 *  Others
 */

#define DEFAULT_TIME_OUT_HTTP 20

/**
 *  Errors
 */
#define CONNECTION_ERROR_TIA_OFFLINE -1001
#define CONNECTION_ERROR_WS_OFFLINE -1004
#define CONNECTION_ERROR_NO_INTERNET -1009
#define CONNECTION_ERROR_CANCELED -999

/**
 *  Webservice types
 */
#define    WebserviceTipoNota      @"1"
#define    WebserviceTipoHorario   @"2"
#define    WebserviceTipoFaltas    @"3"
#define    WebserviceTipoLogin     @"4"
#define    WebserviceTipoAC        @"5"
#define    WebserviceTipoCal       @"6"
#define    WebserviceTipoDesempenho @"7"

/**
 *  Cells
 */
#define CELL_DEFAULT_HEIGHT 44.0f

/**
 *  User Defaults
 */

#define LAST_UPDATE_NOTAS @"last_update_notas"
#define LAST_UPDATE_FALTAS @"last_update_faltas"
#define LAST_UPDATE_HORARIO @"last_update_horario"
#define LAST_UPDATE_CALENDARIO @"last_update_cal"
#define LAST_UPDATE_AC @"last_update_ac"

#define SETTINGS_IS_EM @"isEnsinoMedio"

/**
 *  Update time
 */

#define CACHE_TIME_NOTAS 60*15 //15m
#define CACHE_TIME_FALTAS 60*15 //15m
#define CACHE_TIME_HORARIO 60*60*24*15 //15 dias
#define CACHE_TIME_CALENDARIO 60*60*24*1 //1 dia
#define CACHE_TIME_AC 60*60*24*30 //30 dias

@end
