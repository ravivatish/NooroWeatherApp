//
//  SearchView.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//
import SwiftUI

struct SearchView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    @State var searchText: String = ""
    var body: some View {
        HStack {
            TextField("Search Location", text: $searchText)
                .onChange(of: searchText, initial: true) { _ , newValue in
                    if (searchText != "" ) {
                        weatherViewModel.searchCity(city: newValue)
                    }
                }
                .padding(.leading, 10)
            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.trailing, 10)
        }
        .frame(height: 46)
        .background(Theme.secondaryColor)
        .cornerRadius(20)
        .padding(.horizontal)
        .task {
            weatherViewModel.loadSavedCity()
        }
    }
}
