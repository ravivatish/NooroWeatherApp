//
//  WeatherHome.swift
//  NooroWeatherApp
//
//  Created by ravinder vatish on 12/17/24.
//

import SwiftUI

// Main view for the home screen of the weather app
struct WeatherHome : View {
    
    @StateObject var weatherViewModel = WeatherViewModel(networkRepo: NetworkRepository(), stroageRepo: StorageRepository())

    var body: some View {
        VStack {
            // Search bar at the top
            SearchView(weatherViewModel: weatherViewModel)

            // Dynamically display content based on the app state
            VStack {
                switch(weatherViewModel.appState) {
                    case .noSavedCity:
                        // No saved city yet
                        NoSavedLocationView()
                    case .showCityList:
                        // Show a list of cities
                        WeatherListView(weatherViewModel: weatherViewModel)
                    case .showSavedCity:
                        // Display details for a saved city
                        SavedLocationView(weatherViewModel: weatherViewModel)
                    default:
                        Spacer() // Fallback for unexpected states
                }
            }
        }
    }
}

// View showing detailed weather for a saved city
struct SavedLocationView: View {
    @ObservedObject var weatherViewModel : WeatherViewModel

    var body: some View {
        VStack {
            Spacer().frame(height: 80)

            // Weather icon at the top
            WeatherImageView(weatherViewModel: weatherViewModel, size: 125)

            // City name with a location icon
            HStack {
                Text(weatherViewModel.cityWeather?.location.name ?? "")
                    .font(.poppins(size: 30, weight: .medium))
                Image(systemName: "location.fill")
                    .resizable()
                    .frame(width: 21, height: 21)
                    .foregroundColor(.black)
            }

            // Current temperature
            TempDisplayView(weatherViewModel: weatherViewModel, size: 70)

            Spacer().frame(height: 40)

            // Weather stats like Humidity, UV, and Feels Like
            HStack {
                VStack {
                    Text("Humidity")
                        .font(.poppins(size: 12))
                    Text((weatherViewModel.cityWeather?.current.humidity ?? "") + " %")
                }
                Spacer()
                VStack {
                    Text("UV")
                        .font(.poppins(size: 12))
                    Text(weatherViewModel.cityWeather?.current.uv ?? "")
                }
                Spacer()
                VStack {
                    Text("Feels Like")
                        .font(.poppins(size: 8))
                    Text((weatherViewModel.cityWeather?.current.feelslikeF ?? "") + "°")
                }
            }
            .padding(16)
            .foregroundColor(.gray)
            .background(Theme.secondaryColor)
            .cornerRadius(16)
            .frame(maxWidth: .infinity)
            .padding(40)

            Spacer()
        }
    }
}

// Weather icon displayed dynamically based on condition
struct WeatherImageView: View {
    @ObservedObject var weatherViewModel: WeatherViewModel
    var size: CGFloat

    var body: some View {
        if let iconPath = weatherViewModel.cityWeather?.current.condition.icon,
           let url = URL(string: "https:\(iconPath)") {
            AsyncImage(url: url) { phase in
                switch phase {
                    case .empty:
                        ProgressView() // Shows while loading
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                    @unknown default:
                        Image(systemName: "questionmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                }
            }
            .frame(height: size)
        } else {
            // Placeholder for invalid or missing icons
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
        }
    }
}

// View displayed when no city is selected
struct NoSavedLocationView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("No City Selected")
                .font(.poppins(size: 30, weight: .medium))
            Text("Please Search For A City")
                .font(.poppins(size: 15, weight: .medium))
            Spacer()
        }
    }
}

// View for displaying temperature in a reusable way
struct TempDisplayView : View {
    
    @ObservedObject var weatherViewModel : WeatherViewModel
    var size: CGFloat

    var body : some View {
        HStack(alignment: .top) {
            Text(weatherViewModel.cityWeather?.current.tempF ?? "")
                .font(.poppins(size: size))
            Text("°")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 10) // Align the degree symbol
        }
    }
}

// View to display a list of cities and their weather
struct WeatherListView: View {
    @ObservedObject var weatherViewModel : WeatherViewModel

    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 0){
                // City name
                Text(weatherViewModel.cityWeather?.location.name ?? "")
                    .font(.poppins(size: 30, weight: .medium))
                // Temperature using TempDisplayView
                TempDisplayView(weatherViewModel: weatherViewModel, size: 42)
            }
            Spacer()
            // Weather icon
            WeatherImageView(weatherViewModel: weatherViewModel, size: 120)
        }
        .padding(.leading,32)
        .padding(.trailing, 10)
        .background(Theme.secondaryColor)
        .cornerRadius(16)
        .frame(maxWidth: .infinity)
        .padding(20)
        .onTapGesture(perform: {
            // Update state and refresh data when tapped
            weatherViewModel.appState = .showSavedCity
            weatherViewModel.updateSavedCity()
        })
        Spacer()
    }
}
 
#Preview {
    WeatherHome()
}
