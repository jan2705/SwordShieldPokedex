//
//  HSVSerebiiViewController.m
//  Pokedex
//
//  Created by Hector S. Villasano on 5/11/20.
//  Copyright © 2020 s. All rights reserved.
//

#import "HSVSerebiiViewController.h"
#import <WebKit/WebKit.h>

@interface HSVSerebiiViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation HSVSerebiiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *urlString = [NSString stringWithFormat:@"https://www.serebii.net/pokedex-swsh/%@", self.pokemonName];
    NSURL *url = [NSURL URLWithString:urlString];

    [[self webView] loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
