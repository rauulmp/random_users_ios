//
//  UserRowView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: user.pictureURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.tertiary)
                @unknown default:
                    ProgressView()
                }
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.secondary.opacity(0.1), lineWidth: 1))
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                Text(user.phone)
                    .font(.subheadline)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview("User Row View - Light Mode") {
    UserRowView(user: User.preview)
        .padding()
}

#Preview("Detail View - Failure") {
    UserRowView(user: User.mock(pictureURL: URL(string: "invalid")))
        .padding()
}

#Preview("User Row View - Dark Mode") {
    UserRowView(user: User.preview)
        .padding()
        .preferredColorScheme(.dark)
}
