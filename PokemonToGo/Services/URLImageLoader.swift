import Foundation
import SwiftUI
import Combine

protocol ImageLoaderProtocol {
    func loadImage(url: URL)
}

struct URLImage: View {
    let url: URL
    @StateObject private var imageLoader = ImageLoader()
    
    init(url: URL, ImageLoader: ImageLoader = ImageLoader()) {
        self.url = url
        self._imageLoader = StateObject(wrappedValue: ImageLoader)
    }
    
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

final class ImageLoader: ObservableObject, ImageLoaderProtocol {
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
