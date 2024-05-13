//
//  ProfileRowView.swift
//  Profile Bank App
//
//  Created by Yanisa Phadee on 4/5/2024.
//

import SwiftUI

struct ProfileRowView: View {
    var imageName: String
    var title: String
    var tintColor: Color
    var showChevron: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
                .padding(.leading, 20) // Add padding to shift the image to the right
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading) // Aligns the text to the left
            
            Spacer() // Pushes the arrow to the far right
            
            if showChevron { // Conditionally show chevron based on parameter
                Image(systemName: "chevron.right") // This part is conditional
                .foregroundColor(.gray)
                .padding(.trailing, 20)
                .bold()
            }
               
        }
        .padding(.vertical, 12) // Adjust top and bottom padding as needed
        .background(Color.gray.opacity(0.1)) // Adjust opacity as needed
        .cornerRadius(10)
        .padding(.horizontal, 30) // Add padding to the left and right
    }
}


#Preview {
    ProfileRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray), showChevron: true)
}

