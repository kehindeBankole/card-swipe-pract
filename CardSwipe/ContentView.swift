//
//  ContentView.swift
//  CardSwipe
//
//  Created by Kehinde Bankole on 08/08/2024.
//

import SwiftUI

struct Item: Identifiable {
    var id: UUID = .init()
    var color: Color
}


var cardItems: [Item] = [
    Item(color: .red),
    Item(color: .blue),
    Item(color: .green),
    Item(color: .yellow),
    Item(color: .pink),
    Item(color: .purple),
]

struct Card:View {
    @State var item:Item
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(item.color.gradient)
    }
}


struct ContentView: View {
    @State var items = cardItems
    
    
    func zIndex(item: Item) -> CGFloat {
        
        if let index = items.firstIndex(where: {$0.id == item.id}){
            return (CGFloat(items.count) - CGFloat(index))
 
        }
        return .zero
    }
    
    func progress(proxy: GeometryProxy, limit: CGFloat = 2) -> CGFloat {
        let maxX = proxy.frame(in: .scrollView(axis: .horizontal)).maxX
        let width = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        /// Converting into Progress
        let progress = (maxX / width) - 1
        let cappedProgress = min(progress, limit)

        return cappedProgress
    }
    
    func minX(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        return minX < 0 ? 0 : -minX
    }
    
    func excessMinX(_ proxy: GeometryProxy, offset: CGFloat = 10) -> CGFloat {
        let progress = progress(proxy: proxy)
        
        return progress * offset
    }
    
    func scale(proxy: GeometryProxy, scale: CGFloat = 0.1) -> CGFloat {
        let progress = progress(proxy: proxy)
        
        return 1 - (progress * scale)
    }
    
    var body: some View {
        VStack {
            GeometryReader{ reader in
                ScrollView(.horizontal){
                    HStack(spacing:0){
                        ForEach(items) { item in

                            Card(item: item)
                                .padding(.horizontal, 65)
                                .frame(width: reader.size.width)
                         
                              
                                .visualEffect { content, geometryProxy in
                                       content
                                        .scaleEffect(scale(proxy: geometryProxy, scale: 0.1), anchor: .trailing)
                                        .offset(x: minX(geometryProxy))
                                        .offset(x: excessMinX(geometryProxy, offset:10))
                                }
                                .zIndex(zIndex(item: item))
                               
                        }
                    }
                    .frame(height: 410)
                }
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
            }
        }
        .padding(.top , 100)
    }
}

#Preview {
    ContentView()
}
