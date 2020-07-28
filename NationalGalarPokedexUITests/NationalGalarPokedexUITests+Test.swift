//
//  NationalGalarPokedexUITests+Test.swift
//  NationalGalarPokedexUITests
//
//  Created by Hector Villasano on 7/24/20.
//  Copyright © 2020 s. All rights reserved.
//

import XCTest

//MARK: - Search View
extension NationalGalarPokedexUITests{
    func testPokemonNameListNotNil() {
        XCTAssertNotNil(nationalPokemonNames)
        XCTAssertNotNil(galarPokemonNames)
    }
    
    func testRightBarButtonItemMagnifyingglassISHittable() {
        XCTAssert(rightBarButtonItemMagnifyingglass.isHittable)
        rightBarButtonItemMagnifyingglass.tap()
    }
    
    func testLeftBarButtonItemGearISHittable() {
        XCTAssert(leftBarButtonItemGear.isHittable)
        leftBarButtonItemGear.tap()
    }
    
    
    func testPokedexSearchNavigationBarIsHittable() throws {
        XCTAssert(searchNavigationBar.isHittable)
    }
    
    func testpokedexListTableViewIsHittable() throws {
        XCTAssert(searchListTableView.isHittable)
    }
    
    func testTabBarButtonsIsHittable() {
        XCTAssert(favoritesTabBarButton.isHittable)
        favoritesTabBarButton.tap()
        XCTAssert(leagueCardTabBarButton.isHittable)
        leagueCardTabBarButton.tap()
        XCTAssert(searchTabBarButton.isHittable)
        searchTabBarButton.tap()
    }
    
    func testPokedexNOSheetButtonsIsHittable() {
        for button in pokedexNOSheetButtons {
            leftBarButtonItemGear.tap()
            XCTAssert(button.isHittable)
            button.tap()
        }
    }
    
    func testNavigateTonationalPokemonTableViewList() {
        XCTAssertNoThrow(try navigateToNationalPokemonTableViewList(), "navigateToNationalPokemonTableViewList Error")
    }
    
    func testNavigateToGalarPokemonTableViewList() {
        XCTAssertNoThrow(try navigateToGalarPokemonTableViewList(), "navigateToGalarPokemonTableViewList Error")
    }
    
    func testAllNationalPokemonInTableViewIsHittable() {
        XCTAssertNoThrow(try navigateToNationalPokemonTableViewList(), "navigateToNationalPokemonTableViewList Error")
        XCTAssertNoThrow(try viewAllPokemonFlow(with: [nationalPokemonNames[0]]), "viewAllPokemonFlow Error")
    }
    
    func testAllGalarPokemonInTableViewIsHittable() {
        XCTAssertNoThrow(try navigateToGalarPokemonTableViewList(), "navigateToGalarPokemonTableViewList Error")
        XCTAssertNoThrow(try viewAllPokemonFlow(with: [galarPokemonNames[0]]), "viewAllPokemonFlow Error")
    }
    
    /// pressing the right bar button will show search bar if not present,  remove if present
    func testRightBarButtonItemMagnifyingglassPressed() {
        XCTAssertNoThrow(try searchPokemonSearchBarTappedFlow(), "searchPokemonSearchBarTappedFlow Error")
        rightBarButtonItemMagnifyingglass.tap()
        XCTAssertFalse(searchPokemonSearchBar.waitForExistence(timeout: 1))
    }
        
    /// Use the searchbar to search National pokemon
    func testSearchForNatioanlPokemon() {
        XCTAssert(leftBarButtonItemGear.isHittable)
        leftBarButtonItemGear.tap()
        XCTAssert(pokedexNOSheet.isHittable)
        pokedexNOSheetButtons[0].tap()
        
        let pokemon = nationalPokemonNames.randomElement()!
        let subString = String(pokemon.prefix(3))
        searchForNationalPokemonFlow(with: pokemon, searchString: subString)
    }

    /// Use the searchbar to search galar pokemon
    func testSearchForGalarPokemon() {
        XCTAssert(leftBarButtonItemGear.isHittable)
        leftBarButtonItemGear.tap()
        XCTAssert(pokedexNOSheet.isHittable)
        pokedexNOSheetButtons[1].tap()
        
        let pokemon = nationalPokemonNames.randomElement()!
        let subString = String(pokemon.prefix(3))
        searchForNationalPokemonFlow(with: pokemon, searchString: subString)
    }
}

// MARK: - Favorite View
extension NationalGalarPokedexUITests{
    func testSearchViewFavorites() {
        searchTabBarButton.tap()
        XCTAssert(searchTabBarButton.isSelected)

        let cell = searchListTableView.cells["\(nationalPokemonNames[0])Cell"]
        XCTAssert(cell.isHittable)
        
        let cellHeartButton = cell.buttons["heart"]
        XCTAssert(cellHeartButton.isHittable)
        cellHeartButton.tap()

        leftBarButtonItemGear.tap()
        XCTAssert(pokedexNOSheet.isHittable)
        
        let favoriteButton = pokedexNOSheetButtons[2]
        favoriteButton.tap()
        
        XCTAssert(cell.isHittable)
        
        let cellHeartFillButton = cell.buttons["heart.fill"]
        XCTAssertTrue(cellHeartFillButton.isHittable)
        cellHeartFillButton.tap()
        
        let cellExist = cell.waitForExistence(timeout: 1)
        XCTAssertFalse(cellExist)
        
        leftBarButtonItemGear.tap()
        XCTAssert(pokedexNOSheet.isHittable)
        pokedexNOSheetButtons[0].tap()
        XCTAssert(cellHeartButton.isHittable)
    }
    
    func testNationalPokokemonIsFavorite() {
        XCTAssertNoThrow(try navigateToNationalPokemonTableViewList(), "navigateToNationalPokemonTableViewList Error")
        XCTAssertNoThrow(try favoriteAllPokemonFlow(with: [nationalPokemonNames[2]]), "favoriteAllPokemonFlow Error")
    }
    
    func testGalarPokokemonIsFavorite() {
        XCTAssertNoThrow(try navigateToGalarPokemonTableViewList(), "navigateToGalarPokemonTableViewList Error")
        XCTAssertNoThrow(try favoriteAllPokemonFlow(with: [galarPokemonNames[1]]), "favoriteAllPokemonFlow Error")
    }
}

// MARK: - LEAGUE CARDS VIEW
extension NationalGalarPokedexUITests{
    func testLeagueCardView() {
        XCTAssertNoThrow(try navigateToLeagueCardView(), "navigateToLeagueCardView Error")
    }
    
    func testLeagueCardViewCellTapped() {
        XCTAssertNoThrow(try navigateToLeagueCardView(), "navigateToLeagueCardView Error")
        XCTAssertNoThrow(try  leagueCardViewCellTapped(with: "0000 0000 0000 00"), "leagueCardViewCellTapped Cell")
        XCTAssert(searchTabBarButton.isHittable)
        searchTabBarButton.tap()
        XCTAssert(searchTabBarButton.isSelected)
    }
    
    func testAddLeagueCard_NoiCloudAccountError() {
        XCTAssertNoThrow(try navigateToLeagueCardView(), "navigateToLeagueCardView Error")
        XCTAssertNoThrow(try addLeagueCardFlow(), "addLeagueCardFlow Error")
        XCTAssert(cardCodeNavBarBackButton.isHittable)
        cardCodeNavBarBackButton.tap()
    }
    
    func testAddLeagueCard_SubmitEmptyCodeButtonError() {
        XCTAssertNoThrow(try navigateToLeagueCardView(), "navigateToLeagueCardView Error")
        XCTAssertNoThrow(try addLeagueCardFlow(), "addLeagueCardFlow Error")
        
        let submitButton = app.buttons["Submit"]
        XCTAssert(submitButton.isHittable)
        submitButton.tap()
        
        let alertOKButton = app.alerts["Error"].buttons["OK"]
        XCTAssert(alertOKButton.isHittable)
        alertOKButton.tap()
        
        XCTAssert(cardCodeNavBarBackButton.isHittable)
        cardCodeNavBarBackButton.tap()
    }
    
    func testAddLeagueCardResetButtonisHitable() {
        XCTAssertNoThrow(try navigateToLeagueCardView(), "navigateToLeagueCardView Error")
        XCTAssertNoThrow(try addLeagueCardFlow(), "addLeagueCardFlow Error")
        XCTAssertNoThrow(try AddLeagueCardResetButtonFlow(), "AddLeagueCardResetButtonFlow Error")
        XCTAssert(cardCodeNavBarBackButton.isHittable)
        cardCodeNavBarBackButton.tap()
    }
}
