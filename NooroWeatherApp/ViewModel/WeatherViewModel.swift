import SwiftUI

// Enum to manage different application states
enum AppState {
    case noSavedCity
    case showSavedCity
    case showCityList
    case bankScreen
}

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var cityWeather: WeatherData?
    @Published var appState: AppState = .noSavedCity
    
    private var debounceTask: Task<Void, Never>? = nil
    private var firstLoad = true
    let networkRepo: NetworkRepositoryInterface
    var stroageRepo: StorageInterface
    
    init(networkRepo: NetworkRepositoryInterface, stroageRepo: StorageInterface) {
        self.networkRepo = networkRepo
        self.stroageRepo = stroageRepo
    }
    
    // Fetch weather for a given city asynchronously
    func getWeather(city: String) async {
        let result = await networkRepo.getCityWeather(city)
        switch result {
            case .success(let data):
                cityWeather = data
            case .failure(let error):
                cityWeather = nil
                print(error)
        }
    }
    
    // Update the saved city in storage
    func updateSavedCity() {
        stroageRepo.savedCity = cityWeather?.location.name
    }
    
    // Load the saved city from storage on first load
    func loadSavedCity() {
        if firstLoad {
            if let city = stroageRepo.savedCity {
                Task {
                    await getWeather(city: city)
                    appState = .showSavedCity
                    firstLoad = false // Prevent multiple loads
                }
            }
        }
    }
    
    // Search for a city with debounce logic
    func searchCity(city: String) {
        cityWeather = nil // Reset current weather data
        appState = .bankScreen // Temporary state while searching
        debounceTask?.cancel() // Cancel the previous task
        debounceTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000) // 500ms debounce delay
            if !Task.isCancelled {
                await getWeather(city: city) // Fetch weather data
                if cityWeather != nil {
                    appState = .showCityList // Update state if data is available
                }
            }
        }
    }
}
