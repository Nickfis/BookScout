//
//  ContentView.swift
//  BookScout
//
//  Created by Niklas Fischer on 17/6/23.
//

import SwiftUI
import CoreData
import SotoCore
import SotoRekognition

struct ContentView: View {
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @StateObject private var viewModel = ImageAnalysisViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Use an Image view for the background
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: -50)
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.bottom, 10)
                        Text("Getting all book information...")
                            .padding()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.title2)
                            .background(Color.black.opacity(0.7))
                    }.padding(.horizontal)
                } else {
                    VStack{
                        if viewModel.results.count > 0 {
                            Button(action: {
                                viewModel.clearResults()
                                self.showImagePicker = true
                            }) {
                                Text("Scan Bookshelf")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30))
                                    .background(Color(red: 0.9, green: 0.4, blue: 0.2))
                                    .cornerRadius(10)
                            }
                            ScrollView {
                                Text("Tap any of the books for more info").font(.title2).padding(.top)
                                LazyVStack {
                                    ForEach(viewModel.results, id: \.self) { book in
                                        NavigationLink(destination: DetailedBookView(book: book)) {
                                            BookTile(book: book).foregroundColor(.black)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if viewModel.results.count == 0 {
                            GeometryReader { geometry in
                                Button(action: {
                                    self.showImagePicker = true
                                }) {
                                    Text("Scan Bookshelf")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(EdgeInsets(top: 15, leading: 30, bottom: 15, trailing: 30))
                                        .background(Color(red: 0.9, green: 0.4, blue: 0.2))
                                        .cornerRadius(10)
                                }
                                .position(x: geometry.size.width / 2, y: geometry.size.height * 0.8)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker, onDismiss: { viewModel.loadImage(from: self.inputImage) }) {
            ImagePicker(selectedImage: self.$inputImage, sourceType: .camera)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
