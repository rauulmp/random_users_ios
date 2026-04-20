//
//  InfoRow.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import SwiftUI

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    var url: URL? = nil
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .font(.body.bold())
                .frame(width: 36, height: 36)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let url {
                    Link(value, destination: url)
                        .font(.body)
                        .foregroundStyle(.blue)
                        .lineLimit(2)
                } else {
                    Text(value)
                        .font(.body)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value)")
    }
}

#Preview {
    InfoRow(icon: "envelope.fill",
            title: "Email",
            value: "email@email.com")
}
