//
//  CircularProfileImageView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
    
    var user: User?
    
    init(user: User?) {
        self.user = user
    }
    
    var body: some View {
        if let imageUrl = user?.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
        }else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(.systemGray4))
        }
    }
}

#Preview {
    CircularProfileImageView(user: nil )
}
