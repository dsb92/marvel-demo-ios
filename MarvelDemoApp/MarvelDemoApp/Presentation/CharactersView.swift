import SwiftUI

struct CharactersView: View {
    
    var body: some View {
        ScrollView {
            ForEach(0..<50) { i in
                LazyVStack {
                    AsyncImage(url: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")) { phase in
                        switch phase {
                          case .failure:
                              Image(systemName: "photo")
                                  .font(.largeTitle)
                          case .success(let image):
                              image
                                  .resizable()
                                  .aspectRatio(contentMode: .fill)
                                  .frame(height: 300)
                                  .clipShape(.rect(cornerRadius: 25))
                          default:
                              ProgressView()
                          }
                    }
                    Text("Name \(i)")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                    Text("Description")
                        .font(.title2)
                    
                    Text("Comics")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .background(.green)
                        .foregroundStyle(.white)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { i in
                                Text("Comic \(i)")
                                    .padding()
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(.rect(cornerRadius: 25))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                    
                    Text("Series")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .foregroundStyle(.white)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { i in
                                Text("Serie \(i)")
                                    .padding()
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(.rect(cornerRadius: 25))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                    
                    Text("Stories")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .background(.yellow)
                        .foregroundStyle(.white)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { i in
                                Text("Story \(i)")
                                    .padding()
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(.rect(cornerRadius: 25))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                    
                    
                    Text("Events")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .background(.red)
                        .foregroundStyle(.white)
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<10) { i in
                                Text("Event \(i)")
                                    .padding()
                                    .font(.title3)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .clipShape(.rect(cornerRadius: 25))
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .safeAreaPadding(.horizontal, 40)
                }
            }
        }
    }
}

#Preview {
    CharactersView()
}
