// DetailsTableView.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

///
struct Row: Hashable {
    let title: String
}

/// Таблица деталей о фильме
final class DetailsTableView: UITableView {
    private enum Section {
        case header
        case watch
        case desription
        case info
        case cast
        case language
        case watchMore
    }

    private var sections: [Section] {
        guard let movieDetails else { return [] }
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

    private var viewModel: DetailsViewModelProtocol?
    private var movieDetails: MovieDetails?

    private var diffableDataSource: UITableViewDiffableDataSource<Section, Row>?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTable()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTable()
    }

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

    private func setupTable() {
        dataSource = self
//        separatorStyle = .none
        register(DetailsHeaderTableViewCell.self, forCellReuseIdentifier: DetailsHeaderTableViewCell.cellID)
        register(DetailsWatchTableViewCell.self, forCellReuseIdentifier: DetailsWatchTableViewCell.cellID)
        register(DetailsDescriptionTableViewCell.self, forCellReuseIdentifier: DetailsDescriptionTableViewCell.cellID)
        register(DetailsReleaseInfoTableViewCell.self, forCellReuseIdentifier: DetailsReleaseInfoTableViewCell.cellID)
        register(DetailsLanguageTableViewCell.self, forCellReuseIdentifier: DetailsLanguageTableViewCell.cellID)
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
            return .init()
        case .data:
            let section = sections[indexPath.row]
            return getSectionReusableCell(tableView, for: section)
        default:
            return .init()
        }

//        let section = sections[indexPath.row]
//        return getSectionReusableCell(tableView, for: section)
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
        default:
            return .init()
        }
    }
}
