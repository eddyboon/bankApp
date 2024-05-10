//
//  CircularProfileImageView.swift
//  bankApp
//
//  Created by Yanisa Phadee on 10/5/2024.
//

import SwiftUI

struct CircularProfileImageView: View {
    var body: some View {
        Image("profile")
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProfileImageView()
}
