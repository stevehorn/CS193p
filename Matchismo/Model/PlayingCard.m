//
//  PlayingCard.m
//  Matchismo
//
//  Created by Steve Horn on 6/2/13.
//  Copyright (c) 2013 Steve Horn. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    int suitMatch = 0;
    int rankMatch = 0;
    
    for(PlayingCard *otherCard in otherCards) {
        if([otherCard.suit isEqualToString:self.suit]){
            suitMatch += 1;
        } else if(otherCard.rank == self.rank) {
            rankMatch +=1;
        }
    }
    
    if (suitMatch == otherCards.count) {
        score = 1;
    } else if(rankMatch == otherCards.count) {
        score = 4;
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we provide setter && getter

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuits
{
    return @[@"♥", @"♦", @"♠", @"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [self rankStrings].count - 1;
}


@end