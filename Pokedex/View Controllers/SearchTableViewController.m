//
//  SearchTableViewController.m
//  Pokedex
//
//  Created by s on 4/22/20.
//  Copyright © 2020 s. All rights reserved.
//

#import "SearchTableViewController.h"
#import "HSVNetworking.h"
#import "HSVPokemon.h"

@interface SearchTableViewController ()

@property (nonatomic, copy) HSVNetworking *networking;
@property (nonatomic, readonly, copy) NSArray<HSVPokemon *> *pokemonList;

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self tableView].rowHeight = 70;
    _networking = [HSVNetworking new];

    [_networking fetchPokemonList:^(NSArray<HSVPokemon *> *pokemonList, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            self->_pokemonList = pokemonList;
            [self.tableView reloadData];
        });
    }];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_pokemonList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];

    HSVPokemon *pokemon = [_pokemonList objectAtIndex:indexPath.row];


    cell.textLabel.text = [[pokemon name] capitalizedString];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

@end
