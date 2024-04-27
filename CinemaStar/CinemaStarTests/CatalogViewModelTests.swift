// CatalogViewModelTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import XCTest

final class CatalogViewModelTests: XCTestCase {
    private var catalogViewModel: CatalogViewModel?
    private let mockNetworkService = MockNetworkService()
    private let mockCtalogCoordinator = MockCatalogCoordinator()
    private let mockLoadImageService = MockLoadImageService()

    override func setUpWithError() throws {
        try super.setUpWithError()
        catalogViewModel = CatalogViewModel(
            coordinator: mockCtalogCoordinator,
            loadImageService: mockLoadImageService,
            networkService: mockNetworkService
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        catalogViewModel = nil
    }

    func testViewStateChangeOnSuccessNetworkRequest() {
        guard let catalogViewModel else { return }
        mockNetworkService.shouldResultWithError = false
        let expectation = expectation(description: "viewState change initial-loading-data")
        expectation.expectedFulfillmentCount = 3

        var viewStateChange = 0

        catalogViewModel.viewState.bind { [weak self] viewState in
            guard let self else { return XCTFail("Unexpected self == nil") }
            switch viewStateChange {
            case 0:
                XCTAssertEqual(viewState, .initial)
            case 1:
                XCTAssertEqual(viewState, .loading)
            case 2:
                XCTAssertEqual(viewState, .data(self.mockNetworkService.expectedMovies))
            default:
                XCTFail("Unexpected viewState change")
            }
            viewStateChange += 1
            expectation.fulfill()
        }
        catalogViewModel.fetchMovies()
        waitForExpectations(timeout: 3)
    }

    func testViewStateChangeOnFailedNetworkRequest() {
        guard let catalogViewModel else { return }
        mockNetworkService.shouldResultWithError = true
        let expectation = expectation(description: "viewState change inital-loading-error")
        expectation.expectedFulfillmentCount = 3

        var viewStateChange = 0

        catalogViewModel.viewState.bind { viewState in
            switch viewStateChange {
            case 0:
                XCTAssertEqual(viewState, .initial)
            case 1:
                XCTAssertEqual(viewState, .loading)
            case 2:
                XCTAssertEqual(viewState, .error)
            default:
                XCTFail("Unexpected viewState change")
            }
            viewStateChange += 1
            expectation.fulfill()
        }
        catalogViewModel.fetchMovies()
        waitForExpectations(timeout: 3)
    }

    func testOpensDetailsWithIdUsingCoordinator() {
        let movieId = Int.random(in: 1 ... 300)
        catalogViewModel?.showMovieDetails(id: movieId)
        XCTAssertEqual(mockCtalogCoordinator.openDetailsCallsWithIds.last, movieId)
    }

    func testLoadsImageUsingService() {
        let urlString = "https://google.com"
        guard let url = URL(string: urlString) else { return }
        catalogViewModel?.loadImage(with: url) { _ in }
        XCTAssertEqual(mockLoadImageService.loadImageCallsWithUrls.last, url)
    }
}
