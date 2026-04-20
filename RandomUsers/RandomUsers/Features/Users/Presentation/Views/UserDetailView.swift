//
//  UserDetailView.swift
//  RandomUsers
//
//  Created by Raul Montoya Perez on 18/4/26.
//

import SwiftUI

struct UserDetailView: View {
    
    let user: User
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                
                VStack(spacing: 20) {
                    contactSection
                    locationAndBioSection
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    
    private var headerSection: some View {
        VStack(spacing: 12) {
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
                    EmptyView()
                }
            }
            .frame(width: 140, height: 140)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            .padding(.top, 40)
            
            Text(user.name)
                .font(.title.bold())
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
    
    private var contactSection: some View {
        DetailCardView(title: "Contact Information") {
            InfoRow(icon: "envelope.fill",
                    title: "Email",
                    value: user.email,
                    url: URL(string: "mailto:\(user.email)"))
            
            Divider().padding(.leading, 40)
            
            InfoRow(icon: "phone.fill",
                    title: "Phone",
                    value: user.phone,
                    url: URL(string: "tel:\(user.phone)"))
        }
    }
    
    private var locationAndBioSection: some View {
        DetailCardView(title: "Personal Details") {
            InfoRow(icon: "mappin.and.ellipse", title: "Location", value: user.location)
            
            Divider().padding(.leading, 40)
            
            InfoRow(icon: "calendar", title: "Age", value: "\(user.age) years")
        }
    }
}


#Preview("Detail View - Light Mode") {
    NavigationStack {
        UserDetailView(user: User.preview)
    }
}

#Preview("Detail View - Failure Light Mode") {
    NavigationStack {
        UserDetailView(user: User.mock(pictureURL: URL(string: "invalid")))
    }
}

#Preview("Detail View - Dark Mode") {
    NavigationStack {
        UserDetailView(user: User.preview)
    }
    .preferredColorScheme(.dark)
}

#Preview("Detail View - Failure Dark Mode") {
    NavigationStack {
        UserDetailView(user: User.mock(pictureURL: URL(string: "invalid")))
    }
    .preferredColorScheme(.dark)
}
