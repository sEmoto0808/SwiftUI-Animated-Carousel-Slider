//
//  HomePage.swift
//  Carousel-Slider (iOS)
//
//  Created by Sho Emoto on 2022/01/01.
//

import SwiftUI

struct HomePage: View {
    // MARK: Current Index
    @State var currentIndex = 0

    // MARK: Animation Properties
    @State var bgOffset: CGFloat = 0
    @State var textColor: Color = .white

    // MARK: Text & Image Animation
    @State var textAnimated = false
    @State var imageAnimated = false

    var body: some View {

        VStack {

            let isSmallDevice = getScreenSize().height < 750

            Text(foods[currentIndex].itemTitle)
                .font(.largeTitle.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 100, alignment: .top)
                .offset(y: textAnimated ? 200 : 0)
                .clipped()
                .animation(.easeInOut, value: textAnimated)
                .padding(.top)

            // MARK: Food Details With Image
            HStack(spacing: 10) {

                // MARK: Food Detail
                VStack(alignment: .leading, spacing: 25) {

                    Label {
                        Text("1 Hour")
                    } icon: {
                        Image(systemName: "flame")
                            .frame(width: 30)
                    }

                    Label {
                        Text("40")
                    } icon: {
                        Image(systemName: "bookmark")
                            .frame(width: 30)
                    }

                    Label {
                        Text("Easy")
                    } icon: {
                        Image(systemName: "bolt")
                            .frame(width: 30)
                    }

                    Label {
                        Text("Safety")
                    } icon: {
                        Image(systemName: "safari")
                            .frame(width: 30)
                    }

                    Label {
                        Text("Healthy")
                    } icon: {
                        Image(systemName: "drop")
                            .frame(width: 30)
                    }
                }
                .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: Food Image
                GeometryReader { proxy in

                    let size = proxy.size

                    Image(foods[currentIndex].itemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .rotationEffect(.init(degrees: imageAnimated ? 360 : 0))
                    // MARK: Circle Semi Border
                        .background(
                            Circle()
                                .trim(from: 0.5, to: 1)
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            textColor,
                                            textColor.opacity(0.1),
                                            textColor.opacity(0.1)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 0.7
                                )
                                .padding(-15)
                                .rotationEffect(.init(degrees: -90))
                        )
                        .frame(width: size.width, height: size.width * (isSmallDevice ? 1.5 : 1.8))
                        .frame(maxHeight: .infinity, alignment: .center)
                        .offset(x: 70)
                }
                .frame(height: (getScreenSize().width / 2) * (isSmallDevice ? 1.6 : 2))
            }

            // MARK: Food Description
            Text("A text view draws a string in your app’s user interface using a body font that’s appropriate for the current platform. You can choose a different standard font, like title or caption, using the font(_:) view modifier.")
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineSpacing(8)
                .lineLimit(3)
                .offset(y: textAnimated ? 200 : 0)
                .clipped()
                .animation(.easeInOut, value: textAnimated)
                .padding(.vertical)
        }
        .padding()
        .foregroundColor(textColor)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(

            GeometryReader { proxy in

                let height = proxy.size.height

                LazyVStack(spacing: 0) {

                    ForEach(foods.indices, id: \.self) { index in

                        if index % 2 == 0 {
                            Color("MidnightBlue")
                                .frame(height: height)
                        } else {
                            Color.white
                                .frame(height: height)
                        }
                    }
                }
                .offset(y: bgOffset)
            }
                .ignoresSafeArea()
        )
        .gesture(

            DragGesture()
                .onEnded({ value in

                    if imageAnimated {
                        return
                    }

                    let translation = value.translation.height

                    if translation < 0 && -translation > 50 && currentIndex < foods.count - 1 {

                        // MARK: Swiped Up
                        animateSlide(isUp: true)
                    }

                    if translation > 0 && translation > 50 && currentIndex > 0 {

                        // MARK: Swiped Down
                        animateSlide(isUp: false)
                    }
                })
        )
    }

    private func animateSlide(isUp: Bool) {

        textAnimated = true

        withAnimation(.easeInOut(duration: 0.6)) {
            bgOffset += isUp ? -getScreenSize().height : getScreenSize().height
        }

        withAnimation(.interactiveSpring(response: 1.5, dampingFraction: 0.8, blendDuration: 0.8)) {

            imageAnimated = true
        }

        // Updating Index
        currentIndex = isUp ? currentIndex + 1 : currentIndex - 1

        // MARK: Changing Text Color After Some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {

            textAnimated = false

            withAnimation(.easeInOut) {
                // Automatic Change
                textColor = textColor == .black ? .white : .black
            }
        }

        // Setting Back to Original State after animation Finished
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {

            imageAnimated = false
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

extension View {

    // MARK: Screen Size
    func getScreenSize() -> CGRect {
        UIScreen.main.bounds
    }
}
