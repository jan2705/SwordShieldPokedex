//
//  HSVPokemonController.m
//  Pokedex
//
//  Created by Hector S. Villasano on 4/23/20.
//  Copyright © 2020 s. All rights reserved.
//

#import "HSVPokemonController.h"
#import "HSVPokemon.h"
#import "HSVPokemon+HSVinitWithDictionary.h"
#import "NSError+HSVErrorWithString.h"
#import "AppDelegate.h"

@interface HSVPokemonController()

@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber*, HSVPokemon*> *internalNationalDexDictionary;
@property (nonatomic, copy, readonly) NSMutableDictionary<NSNumber*, HSVPokemon*> *internalGalarDexDictionary;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *internalNationalIndexList;
@property (nonatomic, copy, readonly) NSArray<NSNumber *> *internalGalarDexIndexList;
@property (nonatomic) NSMutableSet<NSNumber *> *internalFavoritePokemon;

@end

@implementation HSVPokemonController

+ (instancetype)sharedPokemonController
{
    static HSVPokemonController *pokemonController = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        pokemonController = [[HSVPokemonController alloc] init];
    });




    return pokemonController;
}

- (instancetype)init
{
    if (self = [super init]) {
        _internalNationalDexDictionary = [NSMutableDictionary new];
        _internalGalarDexDictionary = [NSMutableDictionary new];
        _internalNationalIndexList = [NSArray new];
        _internalFavoritePokemon = [NSMutableSet new];
    }

    [self fetchFromCoreData:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];

    return self;
}

// MARK: - Galar Dex
- (NSDictionary<NSNumber*, HSVPokemon*> *)galarDexDictionary
{
    return _internalGalarDexDictionary;
}

- (NSArray<NSNumber *> *)fetchGalarDexIndexList
{
    return _internalGalarDexIndexList;
}

- (NSUInteger)galarDexListCount
{
    return [_internalGalarDexDictionary count];
}

- (HSVPokemon *)fetchGalarDexpokemonWithIndex:(NSNumber *)index
{
    return [_internalGalarDexDictionary objectForKey:index];
}



// MARK: - National Dex
- (NSDictionary<NSNumber*, HSVPokemon*> *)nationalDexDictionary
{
    return _internalNationalDexDictionary;
}

- (NSUInteger)nationalDexListCount
{
    return [_internalNationalIndexList count];
}

- (HSVPokemon *)fetchNationalDexpokemonWithIndex:(NSNumber *)index
{
    return [_internalNationalDexDictionary objectForKey:index];
}

- (NSArray<NSNumber *> *)pokemonIndexList
{
    return _internalNationalIndexList;
}

// MARK: - Favorites
- (void)addFavorite:(NSNumber *)number
{
    [_internalFavoritePokemon addObject:number];

    [self saveToCoreData:number completion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}

- (void)removeInternalFavoritePokemon:(NSNumber *)object
{
    [_internalFavoritePokemon removeObject:object];
}

- (NSSet<NSNumber *> *)fetchFavorites
{
    return _internalFavoritePokemon;
}

- (NSNumber *)isfavortie:(NSNumber*)indexNumber
{
    return [_internalFavoritePokemon containsObject:indexNumber] ? @YES : @NO;
}

// MARK: - Core Data
- (void)fetchFromCoreData:(void (^)(NSError *))completion
{
    AppDelegate *appdelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectContext *managedContext = appdelegate.persistentContainer.viewContext;
    NSFetchRequest<NSManagedObject*> *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorite"];

    NSError *fetchError = [[NSError new] HSVErrorWithString:@"Error fetching frome core data"];
    NSArray *favoritesArr = [managedContext executeFetchRequest:fetchRequest error:&fetchError] ?: [NSArray array];

    if (!favoritesArr) {
        return completion(fetchError);
    }

    for (NSManagedObject *object in favoritesArr) {
        NSNumber *number = [object valueForKey:@"national_no"];
        [_internalFavoritePokemon addObject:number];
    }

    return completion(nil);
}

- (void)saveToCoreData:(NSNumber *)number completion:(void (^)(NSError *))completion
{
    if (![_internalFavoritePokemon containsObject:number]) { return; }

    AppDelegate *appdelegate = (AppDelegate *)UIApplication.sharedApplication.delegate;
    NSManagedObjectContext *managedContext = appdelegate.persistentContainer.viewContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favorite" inManagedObjectContext:managedContext];
    NSManagedObject *item = [[NSManagedObject new] initWithEntity:entityDescription insertIntoManagedObjectContext:managedContext];
    [item setValue:number forKey:@"national_no"];

    NSError *saveError = [[NSError new] HSVErrorWithString:@"Error savig to core data"];
    [managedContext save:&saveError];

    if (saveError) {
        return completion(saveError);
    }

    return completion(nil);
}



// MARK: - fetchPokemonData
- (void)fetchPokemonDataFromJson:(void (^)(NSArray<NSNumber *> *))completion
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PokemonSwordShield" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error: nil];

    for (NSDictionary *dictionary in dataArray) {
        HSVPokemon *pokemon = [[HSVPokemon new] initWithDictionary:dictionary];

        if ([pokemon.national_dex intValue] <= 890) {
            [_internalNationalDexDictionary addEntriesFromDictionary:@{pokemon.national_dex : pokemon}];

            if (pokemon.galar_dex.intValue > 0)
                [_internalGalarDexDictionary addEntriesFromDictionary:@{pokemon.galar_dex : pokemon}];
        }
    }

    _internalNationalIndexList = [self sortedIndexDictionary:_internalNationalDexDictionary];
    _internalGalarDexIndexList = [self sortedIndexDictionary:_internalGalarDexDictionary];

    return completion(_internalNationalIndexList);
}

//MARK: - sortedIndexDictionary
- (NSArray<NSNumber *> *)sortedIndexDictionary:(NSDictionary *)dictionary
{
    NSArray<NSNumber *> *keys = [dictionary allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];

    return sortedKeys;
}

// MARK: filterWithString
- (NSArray<NSNumber *> *)filterWithString:(NSString *)string dictionary:(NSDictionary<NSNumber *, HSVPokemon *>*)dictionary pokedex_type:(Pokedex)pokedex_type
{
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"(name CONTAINS [cd] %@)", [string lowercaseString]];
    NSArray<HSVPokemon *> *pokemonListArray = [dictionary allValues];
    NSArray<HSVPokemon *> *filteredPokemon = [pokemonListArray filteredArrayUsingPredicate: filterPredicate];

    NSMutableDictionary<NSNumber *, HSVPokemon *> *pokemonDictionary = [NSMutableDictionary new];

    for (HSVPokemon *pokemon in filteredPokemon)
        [pokemonDictionary addEntriesFromDictionary:@{pokedex_type == National ? pokemon.national_dex : pokemon.galar_dex : pokemon}]; //

    return [self sortedIndexDictionary:pokemonDictionary];
}

@end
