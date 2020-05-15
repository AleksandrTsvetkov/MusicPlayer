//
//  Library.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 15.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import SwiftUI
import URLImage

struct Library: View {
    
    @State var tracks = UserDefaults.standard.savedTracks()
    @State private var showingAlert = false
    @State private var track: SearchViewModel.Cell!
    
    var transitionDelegate: TrackDetailViewTransitionDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geometry in
                    HStack(spacing: 20) {
                        Button(action: {
                            self.track = self.tracks[0]
                            self.transitionDelegate?.maximizeTrackDetailView(viewModel: self.track)
                        }) {
                            Image(systemName: "play.fill")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(hex: "FD2D55"))
                                .background(Color(hex: "F3F2F4")).cornerRadius(10)
                        }
                        Button(action: {
                            self.tracks = UserDefaults.standard.savedTracks()
                        }) {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geometry.size.width / 2 - 10, height: 50)
                                .accentColor(Color(hex: "FD2D55"))
                                .background(Color(hex: "F3F2F4")).cornerRadius(10)
                        }
                    }
                }.padding().frame(height: 50)
                Divider().padding(.leading).padding(.trailing)
                List() {
                    ForEach(tracks) { track in
                        LibraryCell(cell: track).gesture(LongPressGesture().onEnded { _ in
                            self.track = track
                            self.showingAlert = true
                        }.simultaneously(with: TapGesture().onEnded({ _ in
                            let window = UIApplication.shared.connectedScenes
                                .filter({ $0.activationState == .foregroundActive })
                                .map({ $0 as? UIWindowScene })
                                .compactMap({ $0 })
                                .first?.windows
                                .filter({ $0.isKeyWindow }).first
                            let mainTabBarController = window?.rootViewController as? MainTabBarController
                            mainTabBarController?.trackDetailView.playlistDelegate = self
                            
                            self.track = track
                            self.transitionDelegate?.maximizeTrackDetailView(viewModel: self.track)
                        })))
                    }.onDelete(perform: delete)
                }
            }.actionSheet(isPresented: $showingAlert, content: {
                ActionSheet(title: Text("Are you sure you want to delete this track"), buttons: [.destructive(Text("Delete"), action: {
                    self.delete(track: self.track)
                }), .cancel()])
            })
                .navigationBarTitle("Library")
        }
    }
    
    private func delete(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
    
    private func delete(track: SearchViewModel.Cell) {
        guard let index = tracks.firstIndex(of: track) else { return }
        tracks.remove(at: index)
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: tracks, requiringSecureCoding: false) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: UserDefaults.favoriteTrackKey)
        }
    }
}

struct LibraryCell: View {
    
    var cell: SearchViewModel.Cell
    
    var body: some View {
        HStack {
            URLImage(URL(string: cell.iconUrlString ?? "")!) { proxy in
                proxy.image
                    .resizable()
                    .frame(width: 60, height: 60)
                    .cornerRadius(2)
            }
            VStack(alignment: .leading) {
                Text(cell.trackName)
                Text(cell.collectionName ?? "").foregroundColor(Color(UIColor(hex: "7E7E85")))
                Text(cell.artistName).foregroundColor(Color(UIColor(hex: "7E7E85")))
            }
        }
    }
}

extension Library: PlaylistNavigationDelegate {
    
    func switchToPreviousTrack() -> SearchViewModel.Cell? {
        guard let index = tracks.firstIndex(of: track) else { return nil }
        var nextTrack: SearchViewModel.Cell
        if index == 0 {
            nextTrack = tracks[tracks.count - 1]
        } else {
            nextTrack = tracks[index - 1]
        }
        self.track = nextTrack
        return nextTrack
    }
    
    func switchToNextTrack() -> SearchViewModel.Cell? {
        guard let index = tracks.firstIndex(of: track) else { return nil }
        var nextTrack: SearchViewModel.Cell
        if index + 1 == tracks.count {
            nextTrack = tracks[0]
        } else {
            nextTrack = tracks[index + 1]
        }
        self.track = nextTrack
        return nextTrack
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        Library()
    }
}
