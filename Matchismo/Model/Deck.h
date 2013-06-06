//
//  Deck.h
//  Matchismo
//
//  Created by Steve Horn on 6/2/13.
//  Copyright (c) 2013 Steve Horn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end