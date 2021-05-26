//
//  MainView.swift
//  Sand
//
//  Created by 许滨麟 on 2021/5/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab = "home"
    @State var showMenu = false
    @Namespace var animation
    var body: some View {
        ZStack {
            Color.green.opacity(0.3).ignoresSafeArea()

            ScrollView(.init(), showsIndicators: false) {
                VStack(alignment: .leading, spacing: 15, content: {
                    Image(systemName: "hare").resizable().aspectRatio(contentMode: .fill).frame(width: 70, height: 70).cornerRadius(10).padding(.top, 50)
                    VStack(alignment: .leading, spacing: 6, content: {
                        Text("Placeh")
                            .font(.title)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                        Button(action: /*@START_MENU_TOKEN@*/ {}/*@END_MENU_TOKEN@*/, label: {
                            Text("Button").fontWeight(.semibold).foregroundColor(.white).opacity(0.7)
                        })
                    })
                    VStack(spacing: 0) {
                        TabButton(image: "hare", title: "hare", selectedTab: $selectedTab, animation: animation)
                        TabButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "Log", selectedTab: $selectedTab, animation: animation)
                            .padding(.leading, -15)

                        TabButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "out", selectedTab: $selectedTab, animation: animation)
                            .padding(.leading, -15)
                    }
                    .padding(.leading, -15)
                    .padding(.top, 50)

                    Spacer()
                    VStack(alignment: .leading, spacing: 6, content: {
                        TabButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "Log out", selectedTab: $selectedTab, animation: animation)
                            .padding(.leading, -15)

                        Text("App Version 1.2.34")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .opacity(0.6)
                    }).frame(height: 111)
                }).padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }

            ZStack {
                Color.white.opacity(0.5).cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0.0)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical, 30)
                Color.white.opacity(0.4).cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0.0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical, 60)
                Color.white.opacity(1).cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0.0)
            }
            .scaleEffect(showMenu ? 0.84 : 1)
            .offset(x: showMenu ? 120 : 0)
            .ignoresSafeArea()
            .overlay(
                // Menu Button...
                Button(action: {
                    withAnimation(.spring()) {
                        showMenu.toggle()
                    }
                }, label: {
                    // Animted Drawer Button..
                    VStack(spacing: 5) {
                        Capsule()
                            .fill(showMenu ? Color.white : Color.primary)
                            .frame(width: 30, height: 3)
                            // Rotating...
                            .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                            .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)

                        VStack(spacing: 5) {
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                            // Moving Up when clicked...
                            Capsule()
                                .fill(showMenu ? Color.white : Color.primary)
                                .frame(width: 30, height: 3)
                                .offset(y: showMenu ? -8 : 0)
                        }
                        .rotationEffect(.init(degrees: showMenu ? 50 : 0))
                    }
                    .contentShape(Rectangle())
                })
                    .padding()

                , alignment: .topLeading
            )
        }
    }
}

// struct SideMenu: View{
//    var body: some View {
//
//    }
// }
struct TabButton: View {
    var image: String
    var title: String
    @Binding var selectedTab: String
    var animation: Namespace.ID
    var body: some View {
        Button(action: {
            withAnimation(.spring()) { selectedTab = title }
        }, label: {
            HStack(spacing: 15) {
                Image(systemName: image)
                    .font(.title2)
                Text(title).fontWeight(.semibold)
            }
            .foregroundColor(selectedTab == title ? .green : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .frame(maxWidth: getRect().width - 170, alignment: .leading)
            .background(
                Group {
                    #if os(iOS)
                        if selectedTab == title {
                            Color.white.opacity(selectedTab == title ? 1 : 0)
                                .clipShape(
                                    CusCorners(corners: [.topRight, .bottomRight], radius: 12)
                                )

                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    #endif
                }
            )
        })
    }
}

#if os(iOS)
    struct CusCorners: Shape {
        var corners: UIRectCorner
        var radius: CGFloat

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
#endif

extension View {
    #if os(macOS)
        func getRect() -> NSRect {
            print(NSScreen.main!.frame.width)
            return NSScreen.main!.frame
        }
    #else
        func getRect() -> CGRect {
            return UIScreen.main.bounds
        }

    #endif
}
