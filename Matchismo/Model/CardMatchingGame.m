//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Steve Horn on 6/4/13.
//  Copyright (c) 2013 Steve Horn. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) int numberOfCards;
@end

@implementation CardMatchingGame

- (NSMutableArray *) cards{
    if(!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck usingNumberOfCards:(int) numberOfCards
{
    self = [super init];
    if(self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if(!card){
                return nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    self.numberOfCards = numberOfCards;
    self.lastAction = @"";
    return self;
}

- (Card *) cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (void) _twoCardModeScoring:(Card *)card
{
    for (Card *otherCard in self.cards) {
        if(otherCard.isFaceUp && !otherCard.isUnplayable) {
            int matchScore = [card match:@[otherCard]];
            if(matchScore){
                otherCard.unplayable = YES;
                card.unplayable = YES;
                int points = matchScore * MATCH_BONUS;
                self.score += points;
                self.lastAction = [NSString stringWithFormat:@"Matched %@ and %@ for %d points.", card.contents, otherCard.contents, points];
            } else {
                otherCard.faceUp = NO;
                self.score -= MISMATCH_PENALTY;
                self.lastAction = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", card.contents, otherCard.contents, MISMATCH_PENALTY];
            }
        }
    }
}

- (void) _threeCardModeScoring:(Card *) card
{
    NSMutableArray *otherCardsSelected = [[NSMutableArray alloc] initWithCapacity:2];
    for (Card *otherCard in self.cards) {
        if(otherCard.isFaceUp && !otherCard.isUnplayable){
            [otherCardsSelected addObject:otherCard];
        }
    }
    
    if(otherCardsSelected.count == 2) {
        NSLog(@"Found 2 other cards to use...");
        int matchScore = [card match:otherCardsSelected];
        if(matchScore) {
            for(Card *otherCard in otherCardsSelected) {
                otherCard.unplayable = YES;
                card.unplayable = YES;
                int points = matchScore * MATCH_BONUS * 2;
                self.score = points;
                self.lastAction = [NSString stringWithFormat:@"Matched for %d points.", points];
            }
        } else {
            for(Card *otherCard in otherCardsSelected) {
                otherCard.faceUp = NO;
                int points = MISMATCH_PENALTY;
                self.score = points;
                self.lastAction = [NSString stringWithFormat:@"Mismatch! %d point penalty!", points];
            }
        }
    } else{
        NSLog(@"Not enough cards to use...");
    }
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable){
        if(!card.isFaceUp) {
            if(self.numberOfCards == 2){
                [self _twoCardModeScoring:card];
            } else if(self.numberOfCards == 3){
                [self _threeCardModeScoring:card];
            }
            self.score -= FLIP_COST;
            
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
