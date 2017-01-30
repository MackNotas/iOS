//
//  MNHorario+Persistence.h
//  MackNotas
//
//  Created by Caio Remedio on 25/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNHorario.h"
#import "DBManager.h"

FOUNDATION_EXPORT NSString * const MNHorarioGroupName;
FOUNDATION_EXPORT NSString * const MNHorarioViewName;

@interface MNHorario (Persistence) <Persistable>

+ (void)saveHorariosFromResponse:(id)response;
+ (void)clearAllData;

@end
