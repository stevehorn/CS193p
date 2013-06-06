//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Steve Horn on 6/2/13.
//  Copyright (c) 2013 Steve Horn. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastActionLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numberOfCardsGameMode;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController
- (IBAction)changeNumberOfCardsGameMode:(UISegmentedControl *)sender {
    [self dealCards:nil];
}

- (IBAction)dealCards:(UIButton *)sender
{
    _game = [_game initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] usingNumberOfCards:[self segmentedControlIndexToNumberOfCards:self.numberOfCardsGameMode.selectedSegmentIndex]];
    
    self.flipCount = 0;
    self.scoreLabel.text = @"";
    [self updateUI];
    NSLog(@"Called dealCards with number of cards %ld", (long)self.numberOfCardsGameMode.selectedSegmentIndex);
}

- (CardMatchingGame *) game
{
    if(!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]usingNumberOfCards:[self segmentedControlIndexToNumberOfCards:self.numberOfCardsGameMode.selectedSegmentIndex]];
    }
    return _game;
}   

- (void) setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        if(!card.isFaceUp) {
            UIImage *cardBackImage = [UIImage imageNamed:@"pie-icon.png"];
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        } else {
            [cardButton setImage:nil forState:UIControlStateNormal];
        }
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = (card.isUnplayable ? .3 : 1);
    }
    
    if(self.flipCount == 0) {
        self.numberOfCardsGameMode.enabled = YES;
    } else {
        self.numberOfCardsGameMode.enabled = NO;
    }
    self.lastActionLabel.text = self.game.lastAction;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setFlipCount:(int)flipCount{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"Flips updated to %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    
    [self updateUI];
}

- (void)viewDidLoad
{
    self.lastActionLabel.text = @"";
}

- (int)segmentedControlIndexToNumberOfCards:(int)controlIndex
{
    if(controlIndex == 0) {
        return 2;
    } else if(controlIndex == 1) {
        return 3;
    } else {
        return -1; //sum ting wong
    }
}

@end
