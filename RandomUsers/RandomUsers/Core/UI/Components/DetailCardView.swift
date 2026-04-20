//
//  DetailCardView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import SwiftUI

struct DetailCardView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title.uppercased())
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.leading, 5)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
        }
    }
}

#Preview {
    DetailCardView(title: "Info", content: {
        InfoRow(icon: "envelope.fill",
                title: "Email",
                value: "email@email.com")
    })
}
