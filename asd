using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using WeatherApp.Extensions;
using WeatherApp.Models;

namespace WeatherApp.Services
{
    public class WeatherService
    {
        private readonly string _apiKey;
        private readonly HttpClient _httpClient = new();

        public WeatherService()
        {
            _apiKey = App.Configuration.GetSection("ApiKeys")["WeatherApi"];
            if (string.IsNullOrEmpty(_apiKey))
            {
                throw new Exception("Weather API key not found in appsettings.json");
            }
        }

        public async Task<Weather> GetWeatherByCityNameAsync(string cityName)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };
            options.Converters.Add(new WeatherJsonConverter());

            var url = $"https://api.openweathermap.org/data/2.5/weather?q={cityName}&appid={_apiKey}&units=metric&lang=ru";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
                throw new Exception("Ошибка при получении данных погоды");

            var json = await response.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<Weather>(json, options)!;
        }

        public async Task<Weather> GetWeatherByGeoAsync(double longitude, double latitude)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };
            options.Converters.Add(new WeatherJsonConverter());

            var url = $"https://api.openweathermap.org/data/2.5/weather?lat={latitude}&lon={longitude}&appid={_apiKey}&units=metric&lang=ru";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
                throw new Exception("Ошибка при получении данных погоды по координатам");

            var json = await response.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<Weather>(json, options)!;
        }

        public async Task<List<City>> GetGeoByCityNameAsync(string cityName, int limit = 1)
        {
            var options = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            };
            options.Converters.Add(new CityJsonConverter());

            var url = $"http://api.openweathermap.org/geo/1.0/direct?q={cityName}&limit={limit}&appid={_apiKey}";
            var response = await _httpClient.GetAsync(url);

            if (!response.IsSuccessStatusCode)
                throw new Exception("Ошибка при получении геоданных");

            var json = await response.Content.ReadAsStringAsync();
            return JsonSerializer.Deserialize<List<City>>(json, options)!;
        }
    }

}

