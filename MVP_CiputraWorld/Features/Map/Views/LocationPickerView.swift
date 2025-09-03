//
//  LocationPickerView.swift
//  MVP_CiputraWorld
//
//  Created by Niken Larasati on 03/09/25.
//

import SwiftUI
import UIKit

// Helper: konversi koordinat relatif ke posisi layar sesuai scaledToFit
extension CGPoint {
    func positionIn(imageSize: CGSize, geoSize: CGSize) -> CGPoint {
        let imageAspect = imageSize.width / imageSize.height
        let geoAspect = geoSize.width / geoSize.height
        
        var scale: CGFloat
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        
        if imageAspect > geoAspect {
            // Gambar lebih lebar
            scale = geoSize.width / imageSize.width
            let renderedHeight = imageSize.height * scale
            yOffset = (geoSize.height - renderedHeight) / 2
        } else {
            // Gambar lebih tinggi
            scale = geoSize.height / imageSize.height
            let renderedWidth = imageSize.width * scale
            xOffset = (geoSize.width - renderedWidth) / 2
        }
        
        let x = self.x * imageSize.width * scale + xOffset
        let y = self.y * imageSize.height * scale + yOffset
        return CGPoint(x: x, y: y)
    }
}

struct LocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: CGPoint?  // Koordinat relatif (0..1)
    
    @State private var tempLocation: CGPoint? = nil
    @State private var showConfirmation = false
    
    let floorMapImage = "map"
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    ZStack {
                        GeometryReader { geo in
                            if let uiImage = UIImage(named: floorMapImage) {
                                let imageSize = uiImage.size
                                
                                Image(floorMapImage)
                                    .resizable()
                                    .scaledToFit()
                                    .onTapGesture { tap in
                                        // Hitung posisi relatif
                                        let imageAspect = imageSize.width / imageSize.height
                                        let geoAspect = geo.size.width / geo.size.height
                                        
                                        var scale: CGFloat
                                        var xOffset: CGFloat = 0
                                        var yOffset: CGFloat = 0
                                        
                                        if imageAspect > geoAspect {
                                            scale = geo.size.width / imageSize.width
                                            let renderedHeight = imageSize.height * scale
                                            yOffset = (geo.size.height - renderedHeight) / 2
                                        } else {
                                            scale = geo.size.height / imageSize.height
                                            let renderedWidth = imageSize.width * scale
                                            xOffset = (geo.size.width - renderedWidth) / 2
                                        }
                                        
                                        let relativeX = (tap.x - xOffset) / (imageSize.width * scale)
                                        let relativeY = (tap.y - yOffset) / (imageSize.height * scale)
                                        
                                        guard relativeX >= 0, relativeX <= 1, relativeY >= 0, relativeY <= 1 else { return }
                                        
                                        tempLocation = CGPoint(x: relativeX, y: relativeY)
                                        let impact = UIImpactFeedbackGenerator(style: .light)
                                        impact.impactOccurred()
                                        showConfirmation = true
                                    }
                                
                                if let location = tempLocation {
                                    let screenPoint = location.positionIn(imageSize: imageSize, geoSize: geo.size)
                                    ZStack {
                                        Circle().fill(Color.blue.opacity(0.3)).frame(width: 60, height: 60)
                                        Circle().fill(Color.blue).frame(width: 20, height: 20)
                                    }
                                    .position(screenPoint)
                                    .animation(.easeInOut, value: tempLocation)
                                }
                            }
                        }
                    }
                    .padding(16)
                    
                    Spacer()
                }
                
                // Bottom Sheet Konfirmasi
                if showConfirmation {
                    VStack {
                        Spacer()
                        VStack(spacing: 16) {
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: 36, height: 5)
                                .cornerRadius(3)
                                .padding(.top, 12)
                            
                            Spacer().frame(height: 20)
                            
                            Button {
                                selectedLocation = tempLocation
                                dismiss()
                            } label: {
                                Text("Konfirmasi")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(Color(red: 0.11, green: 0.16, blue: 0.31))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 34)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                        .padding(.bottom, 80) // Add padding to move up from the bottom
                    }
                    .ignoresSafeArea(edges: .bottom)
                }

            }
        }
        .navigationTitle("Tambahkan Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        LocationPickerView(selectedLocation: .constant(nil))
    }
}
