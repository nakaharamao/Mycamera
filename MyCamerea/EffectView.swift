//
//  EffectView.swift
//  MyCamerea
//
//  Created by 中原麻央 on 2023/01/04.
//

import SwiftUI

struct EffectView: View {
    
    @Binding var isShowSheet: Bool
    let captuerImage: UIImage
    
    @State var showImage: UIImage?
    
    var body: some View {
        VStack{
            Spacer()
            if let showImage{
                Image(uiImage: showImage)
                    .resizable()
                    .scaledToFit()
            }
            Spacer()
            Button{
                let filterName = "CIPhotoEffectMono"
                let rotate = captuerImage.imageOrientation
                let inputImage = CIImage(image: captuerImage)
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                effectFilter.setDefaults()
                effectFilter.setValue(
                    inputImage,forKey: kCIInputImageKey)
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                let ciContext = CIContext(options: nil)
                guard let cgImage = ciContext.createCGImage(outputImage, from:
                                                                outputImage.extent) else {
                    return
                }
                showImage = UIImage(
                    cgImage: cgImage,
                    scale:  1.0,
                    orientation: rotate
                    )
            }label: {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            if let showImage = showImage?.resized(),
               let shareImage = Image(uiImage: showImage) {
                ShareLink(item: shareImage, subject: nil, message: nil,
                          preview: SharePreview("Photo", image: shareImage)) {
                    Text("シェア")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .multilineTextAlignment(.center)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                }
                          .padding()
            }
            Button {
                isShowSheet.toggle()
            }label: {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .onAppear{
            showImage = captuerImage
        }
    }
}
struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: .constant(true),
            captuerImage: UIImage(named: "preview_use")!
        )
    }
}
