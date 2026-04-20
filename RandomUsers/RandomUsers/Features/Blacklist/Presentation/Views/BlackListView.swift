//
//  BlackListView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 19/4/26.
//

import SwiftUI

struct BlacklistView: View {
    @State var viewModel: BlacklistViewModel
    
    var body: some View {
        Group {
            if viewModel.blockedUsers.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
        .navigationTitle("Blacklisted Users")
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Blacklisted Users Found", systemImage: "person.slash")
        } description: {
            Text("There are no blacklisted users.")
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.blockedUsers) { user in
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .onDelete(perform: viewModel.removeUser)
        }
    }
}

#Preview("User List View - Light Mode") {
    let container = PreviewContainer(
        blacklistUsers: BlacklistUser.previewList
    )
    
    BlacklistView(
        viewModel: container.makeBlacklistViewModel()
    )
}

#Preview("User List View - Empty - Light Mode") {
    let container = PreviewContainer()
    BlacklistView(
        viewModel: container.makeBlacklistViewModel()
    )
}

#Preview("User List View - Dark Mode") {
    let container = PreviewContainer(
        blacklistUsers: BlacklistUser.previewList
    )
    
    BlacklistView(
        viewModel: container.makeBlacklistViewModel()
    )
    .preferredColorScheme(.dark)
}
