//
//  ProfileRowView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 4/5/2024.
//

import SwiftUI

struct ProfileRowView: View {
    
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
            
            
        }
    }
}

#Preview {
    ProfileRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
}

