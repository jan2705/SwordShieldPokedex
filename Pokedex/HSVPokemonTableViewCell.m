//
//  HSVPokemonTableViewCell.m
//  Pokedex
//
//  Created by s on 4/22/20.
//  Copyright © 2020 s. All rights reserved.
//

#import "HSVPokemonTableViewCell.h"
#import "HSVPokemon.h"

@implementation HSVPokemonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)favoriteButtonPressed:(id)sender {
    NSLog(@"favorite button");
}

@end
