import Foundation
import SwiftUI
import Combine

struct URLImage: View {
    let url: URL
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        if let image = imageLoader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .onAppear {
                    imageLoader.loadImage(url: url)
                }
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private var cancellable: AnyCancellable?
    
    func loadImage(url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}
