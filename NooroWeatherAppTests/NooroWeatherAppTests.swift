import XCTest
@testable import NooroWeatherApp

@MainActor
final class WeatherViewModelTests: XCTestCase {

    var viewModel: WeatherViewModel!
    var mockNetworkRepo: MockNetworkRepository!
    var mockStorageRepo: MockStorageRepository!

    override func setUp() {
        super.setUp()
        mockNetworkRepo = MockNetworkRepository()
        mockStorageRepo = MockStorageRepository()
        viewModel = WeatherViewModel(networkRepo: mockNetworkRepo, stroageRepo: mockStorageRepo)
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkRepo = nil
        mockStorageRepo = nil
        super.tearDown()
    }

    func testGetWeatherSuccess() async {
        // Mock a successful weather data response
        mockNetworkRepo.mockResult = .success(WeatherData(location: Location(name: "Denver"), current: CurrentCityWeather(tempF: 75.0, humidity: 30, feelslikeF: 72.0, uv: 5.0, condition: WeatherCondition(icon: "icon.png"))))

        await viewModel.getWeather(city: "Denver")

        XCTAssertEqual(viewModel.cityWeather?.location.name, "Denver")
        XCTAssertEqual(viewModel.cityWeather?.current.tempF, "75.0")
        XCTAssertEqual(viewModel.cityWeather?.current.humidity, "30")
        XCTAssertEqual(viewModel.cityWeather?.current.feelslikeF, "72.0")
        XCTAssertEqual(viewModel.cityWeather?.current.uv, "5.0")
    }

    func testGetWeatherFailure() async {
        // Mock a failure response
        mockNetworkRepo.mockResult = .failure(NetworkErrors.requestFailed)

        await viewModel.getWeather(city: "InvalidCity")

        XCTAssertNil(viewModel.cityWeather)
    }

    func testLoadSavedCity() async {
        // Mock saved city and successful weather data
        mockStorageRepo.savedCity = "Denver"
        mockNetworkRepo.mockResult = .success(WeatherData(location: Location(name: "Denver"), current: CurrentCityWeather(tempF: 75.0, humidity: 30, feelslikeF: 72.0, uv: 5.0, condition: WeatherCondition(icon: "icon.png"))))

        viewModel.loadSavedCity()

        // Wait for the task to complete
        try! await  Task.sleep(nanoseconds: 100_000_000)

        XCTAssertEqual(viewModel.appState, .showSavedCity)
        XCTAssertEqual(viewModel.cityWeather?.location.name, "Denver")
    }

    func testSearchCity() async {
        // Mock search city response
        mockNetworkRepo.mockResult = .success(WeatherData(location: Location(name: "Boulder"), current: CurrentCityWeather(tempF: 65.0, humidity: 40, feelslikeF: 64.0, uv: 6.0, condition: WeatherCondition(icon: "icon.png"))))

        viewModel.searchCity(city: "Boulder")

        // Wait for debounce delay
        try! await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(viewModel.appState, .showCityList)
        XCTAssertEqual(viewModel.cityWeather?.location.name, "Boulder")
        XCTAssertEqual(viewModel.cityWeather?.current.tempF, "65.0")
        XCTAssertEqual(viewModel.cityWeather?.current.humidity, "40")
        XCTAssertEqual(viewModel.cityWeather?.current.feelslikeF, "64.0")
        XCTAssertEqual(viewModel.cityWeather?.current.uv, "6.0")
    }
}

// Mock implementations for testing
final class MockNetworkRepository: NetworkRepositoryInterface {
    var mockResult: Result<WeatherData, NetworkErrors>?

    func getCityWeather(_ city: String) async -> Result<WeatherData, NetworkErrors> {
        return mockResult ?? .failure(NetworkErrors.unknownError(NSError(domain: "MockError", code: -1, userInfo: nil)))
    }
}

final class MockStorageRepository: StorageInterface {
    var savedCity: String?
}
