//
//  MergeImageDemo.swift
//  SwiftUIDemo5
//
//  Created by Itsuki on 2025/05/10.
//

import SwiftUI

struct MergeImageDemo: View {
    @Environment(\.displayScale) var displayScale

    var body: some View {
        VStack(spacing: 36) {
            HStack(spacing: 24) {
                Image("pikachu")
                VStack(alignment: .leading) {
                    HStack(spacing: 24) {
                        Text("+")
                        
                        Text("I love pikachu!")
                            .foregroundStyle(.red)
                            .fontWeight(.semibold)
                    }
                    HStack(spacing: 24) {
                        Text("+")
                        Rectangle()
                            .fill(.red)
                            .frame(width: 12, height: 12)
                        Text("+")
                        Image(systemName: "heart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.red)
                    }
                }
            }
            
            VStack {
                Text("With `UIGraphicsImageRenderer`")
                    .font(.headline)
                let uiImage = withUIGraphicsImageRenderer()
                Image(uiImage: uiImage)
            }
            
            VStack {
                Text("With SwiftUI `ImageRenderer`")
                    .font(.headline)
                if let uiImage2 = withSwiftUIImageRenderer(scale: self.displayScale) {
                    Image(uiImage: uiImage2)
                } else {
                    Text("Failed to create UIImage")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.1))
    }

    
    func withSwiftUIImageRenderer(scale: CGFloat) -> UIImage? {
        var view: some View {
            let uiImage = UIImage(named: "pikachu")!
            let text = "I love pikachu!"

            return Image(uiImage: uiImage)
                .overlay(alignment: .topLeading, content: {
                    Text(text)
                        .foregroundStyle(.red)
                        .fontWeight(.semibold)
                        .padding(.all, 12)
                })
                .overlay(alignment: .topTrailing, content: {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 12, height: 12)
                })
                .overlay(alignment: .bottomTrailing, content: {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.red)
                })
                .border(.red, width: 1)
        }
        
        let renderer = ImageRenderer(content: view)
        renderer.scale = scale
        return renderer.uiImage
    }
    
    
    func withUIGraphicsImageRenderer() -> UIImage {
        let uiImage = UIImage(named: "pikachu")!
        let text = "I love pikachu!"

        let size = uiImage.size
        
        let renderer = UIGraphicsImageRenderer(size:size)
    
        let image = renderer.image { context in
        
            uiImage.draw(in: CGRect(origin: .zero, size: size))
            
            let textRect = CGRect(x: 10, y: 10, width: size.width - 10, height: 24)
            let textFontAttributes = [
               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
               NSAttributedString.Key.foregroundColor: UIColor.red,
            ]

            text.draw(in: textRect, withAttributes: textFontAttributes)
            
            let rectangle = UIBezierPath(roundedRect: CGRect(origin: .init(x: size.width - 12, y: 0), size: CGSize(width: 12, height: 12)), cornerRadius: 0)
            rectangle.stroke()
            rectangle.fill()
            
            let heart = UIImage(systemName: "heart.fill")!.withRenderingMode(.alwaysTemplate).withTintColor(.red)
            heart.draw(in: CGRect(x: size.width - 24, y: size.height - 24, width: 24, height: 24))
            
            
            UIColor.red.setStroke()
            context.stroke(CGRect(origin: .zero, size: size))
            
        }
        
        return image
    }
}


//private struct



#Preview {
    MergeImageDemo()
}
