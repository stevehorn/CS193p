//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Steve Horn on 6/4/13.
//  Copyright (c) 2013 Steve Horn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject
- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *) deck usingNumberOfCards:(int) numberOfCards;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
@property (nonatomic, readonly) int score;
@property (nonatomic) NSString *lastAction;
@end
