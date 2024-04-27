// DetailsViewModelTests.swift
// Copyright © RoadMap. All rights reserved.

@testable import CinemaStar
import XCTest

final class DetailsViewModelTests: XCTestCase {
    private var detailsViewModel: DetailsViewModel?
    private let mockNetworkService = MockNetworkService()
    private let mockCtalogCoordinator = MockCatalogCoordinator()
    private let mockLoadImageService = MockLoadImageService()
    private let mockStorageService = MockStorageService()
    private let movieId = 1234

    override func setUpWithError() throws {
        try super.setUpWithError()
        detailsViewModel = DetailsViewModel(
            movieId: movieId,
            coordinator: mockCtalogCoordinator,
            storageService: mockStorageService,
            loadImageService: mockLoadImageService,
            networkService: mockNetworkService
        )
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        detailsViewModel = nil
    }

    func testViewStateChangeOnSuccessNetworkRequest() {
        guard let detailsViewModel else { return }
        mockNetworkService.shouldResultWithError = false
        let expectation = expectation(description: "viewState change initial-loading-data")
        expectation.expectedFulfillmentCount = 3

        var viewStateChange = 0

        detailsViewModel.viewState.bind { [weak self] viewState in
            guard let self else { return XCTFail("Unexpected self == nil") }
            switch viewStateChange {
            case 0:
                XCTAssertEqual(viewState, .initial)
            case 1:
                XCTAssertEqual(viewState, .loading)
            case 2:
                XCTAssertEqual(viewState, .data(self.mockNetworkService.expectedMovieDetails))
            default:
                XCTFail("Unexpected viewState change")
            }
            viewStateChange += 1
            expectation.fulfill()
        }
        detailsViewModel.fetchMovieDetails()
        waitForExpectations(timeout: 3)
    }

    func testViewStateChangeOnFailedNetworkRequest() {
        guard let detailsViewModel else { return }
        mockNetworkService.shouldResultWithError = true
        let expectation = expectation(description: "viewState change inital-loading-error")
        expectation.expectedFulfillmentCount = 3

        var viewStateChange = 0

        detailsViewModel.viewState.bind { viewState in
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
        detailsViewModel.fetchMovieDetails()
        waitForExpectations(timeout: 3)
    }

    func testWatchMovieTriggersAlert() {
        guard let detailsViewModel else { return }
        XCTAssertNil(detailsViewModel.alertMessage.value)
        detailsViewModel.watchMovie()
        XCTAssertNotNil(detailsViewModel.alertMessage.value)
    }

    func testLoadsImageUsingService() {
        let urlString = "https://google.com"
        guard let url = URL(string: urlString) else { return }
        detailsViewModel?.loadImage(with: url) { _ in }
        XCTAssertEqual(mockLoadImageService.loadImageCallsWithUrls.last, url)
    }

    func testIsFavoriteFlagChanges() {
        guard let detailsViewModel else { return }
        XCTAssertFalse(detailsViewModel.isFavorite.value)
        detailsViewModel.handleToggleFavorite()
        XCTAssertTrue(detailsViewModel.isFavorite.value)
        detailsViewModel.handleToggleFavorite()
        XCTAssertFalse(detailsViewModel.isFavorite.value)
    }
}
