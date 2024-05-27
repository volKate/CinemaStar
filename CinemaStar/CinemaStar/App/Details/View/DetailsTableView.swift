// DetailsTableView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Таблица деталей о фильме
final class DetailsTableView: UITableView {
    // MARK: - Constants

    private enum Section {
        case header
        case watch
        case desription
        case info
        case cast
        case language
        case watchMore
        case placeholder
    }

    // MARK: - Private Properties

    private var viewModel: DetailsViewModelProtocol?
    private var movieDetails: MovieDetails?

    private var sections: [Section] {
        guard let movieDetails else { return [.placeholder] }
        var sections = [Section.header, .watch, .desription, .info]
        if !movieDetails.actors.isEmpty {
            sections.append(.cast)
        }
        if movieDetails.language != nil {
            sections.append(.language)
        }
        if let similarMovies = movieDetails.similarMovies, !similarMovies.isEmpty {
            sections.append(.watchMore)
        }
        return sections
    }

    // MARK: - Initializers

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTable()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTable()
    }

    // MARK: - Public Methods

    func configure(with viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        viewModel.viewState.bind { [weak self] viewState in
            switch viewState {
            case let .data(movieDetails):
                self?.movieDetails = movieDetails
            default:
                self?.movieDetails = nil
            }
            self?.reloadData()
        }
    }

    // MARK: - Private Methods

    private func setupTable() {
        dataSource = self
        separatorStyle = .none
        registerCells()
    }

    private func registerCells() {
        register(DetailsHeaderTableViewCell.self, forCellReuseIdentifier: DetailsHeaderTableViewCell.cellID)
        register(DetailsWatchTableViewCell.self, forCellReuseIdentifier: DetailsWatchTableViewCell.cellID)
        register(DetailsDescriptionTableViewCell.self, forCellReuseIdentifier: DetailsDescriptionTableViewCell.cellID)
        register(DetailsReleaseInfoTableViewCell.self, forCellReuseIdentifier: DetailsReleaseInfoTableViewCell.cellID)
        register(DetailsLanguageTableViewCell.self, forCellReuseIdentifier: DetailsLanguageTableViewCell.cellID)
        register(DetailsShimmerTableViewCell.self, forCellReuseIdentifier: DetailsShimmerTableViewCell.cellID)
        register(DetailsActorsTableViewCell.self, forCellReuseIdentifier: DetailsActorsTableViewCell.cellID)
        register(
            DetailsRecommendationsTableViewCell.self,
            forCellReuseIdentifier: DetailsRecommendationsTableViewCell.cellID
        )
    }
}

// MARK: - DetailsTableView + UITableViewDataSource

extension DetailsTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel?.viewState.value {
        case .loading:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsShimmerTableViewCell
                        .cellID
                ) as? DetailsShimmerTableViewCell else { return .init() }
            isScrollEnabled = false
            return cell
        case .data:
            let section = sections[indexPath.row]
            isScrollEnabled = true
            return getSectionReusableCell(tableView, for: section)
        default:
            return .init()
        }
    }

    private func getSectionReusableCell(_ tableView: UITableView, for section: Section) -> UITableViewCell {
        guard let movieDetails else { return .init() }
        switch section {
        case .header:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsHeaderTableViewCell
                        .cellID
                ) as? DetailsHeaderTableViewCell else { return .init() }
            cell.configure(title: movieDetails.name, rating: movieDetails.kpRating)
            if let url = movieDetails.posterUrl {
                viewModel?.loadImage(with: url, completion: { data in
                    guard let data else { return }
                    cell.setImage(data: data)
                })
            }
            return cell
        case .watch:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsWatchTableViewCell
                        .cellID
                ) as? DetailsWatchTableViewCell else { return .init() }
            cell.configure(viewModel: viewModel)
            return cell
        case .desription:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsDescriptionTableViewCell
                        .cellID
                ) as? DetailsDescriptionTableViewCell else { return .init() }
            cell.configure(description: movieDetails.description)
            return cell
        case .info:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsReleaseInfoTableViewCell
                        .cellID
                ) as? DetailsReleaseInfoTableViewCell else { return .init() }
            cell.configure(releaseInfo: movieDetails.releaseInfo)
            return cell
        case .language:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsLanguageTableViewCell
                        .cellID
                ) as? DetailsLanguageTableViewCell else { return .init() }
            cell.configure(language: movieDetails.language ?? "")
            return cell
        case .cast:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsActorsTableViewCell
                        .cellID
                ) as? DetailsActorsTableViewCell else { return .init() }
            cell.configure(actors: movieDetails.actors, viewModel: viewModel)
            return cell

        case .watchMore:
            guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: DetailsRecommendationsTableViewCell
                        .cellID
                ) as? DetailsRecommendationsTableViewCell else { return .init() }
            cell.configure(previews: movieDetails.similarMovies ?? [], viewModel: viewModel)
            return cell
        default:
            return .init()
        }
    }
}
