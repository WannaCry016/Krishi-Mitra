import requests
from datetime import datetime, timedelta
from fastapi import APIRouter
from pydantic import BaseModel

weather_router = APIRouter()

# Weather code mapping
weather_conditions = {
    0: "Clear sky ☀️",
    1: "Mainly clear 🌤️",
    2: "Partly cloudy ⛅",
    3: "Overcast ☁️",
    45: "Fog 🌫️",
    48: "Depositing rime fog 🌫️❄️",
    51: "Light drizzle 🌦️",
    53: "Moderate drizzle 🌧️",
    55: "Dense drizzle 🌧️",
    56: "Light freezing drizzle ❄️🌧️",
    57: "Dense freezing drizzle ❄️🌧️",
    61: "Slight rain 🌦️",
    63: "Moderate rain 🌧️",
    65: "Heavy rain 🌧️🌧️",
    66: "Light freezing rain ❄️🌧️",
    67: "Heavy freezing rain ❄️🌧️",
    71: "Slight snowfall ❄️",
    73: "Moderate snowfall ❄️❄️",
    75: "Heavy snowfall ❄️❄️❄️",
    77: "Snow grains ❄️",
    80: "Slight rain showers 🌦️",
    81: "Moderate rain showers 🌧️",
    82: "Violent rain showers 🌧️🌧️",
    85: "Slight snow showers ❄️🌦️",
    86: "Heavy snow showers ❄️🌧️",
    95: "Thunderstorm ⛈️",
    96: "Thunderstorm with slight hail ⛈️❄️",
    99: "Thunderstorm with heavy hail ⛈️❄️❄️"
}

# Request body structure for the user's input
class UserInput(BaseModel):
    lat: float
    lon: float

@weather_router.post("/")
def get_weather_forecast(input: UserInput, days=7):
    """
    Fetch hourly weather forecast for the next few days at specific times (morning, afternoon, evening, night).
    """
    url = f"https://api.open-meteo.com/v1/forecast?latitude={input.lat}&longitude={input.lon}&hourly=temperature_2m,weathercode,precipitation,windspeed_10m&timezone=auto"
    response = requests.get(url)

    if response.status_code == 200:
        data = response.json()
        times = data["hourly"]["time"]
        temperatures = data["hourly"]["temperature_2m"]
        weather_codes = data["hourly"]["weathercode"]
        precipitation = data["hourly"]["precipitation"]
        wind_speeds = data["hourly"]["windspeed_10m"]

        forecast = {}

        # Convert times to datetime objects
        time_objects = [datetime.fromisoformat(t) for t in times]

        # Define target times (midnight, morning, afternoon, evening)
        target_hours = [0, 6, 12, 18]  # 00:00, 06:00, 12:00, 18:00

        print(f"Weather forecast for the next {days} days:")
        for i in range(len(times)):
            dt = time_objects[i]
            if dt.hour in target_hours and dt.date() <= (datetime.today() + timedelta(days=days)).date():
                date_str = dt.strftime("%Y-%m-%d")
                time_str = dt.strftime("%H:%M")

                if date_str not in forecast:
                    forecast[date_str] = []
                
                weather_desc = weather_conditions.get(weather_codes[i], "Unknown Condition")
                
                forecast[date_str].append({
                    "time": time_str,
                    "temperature": temperatures[i],
                    "weather": weather_desc,
                    "precipitation": precipitation[i],
                    "wind_speed": wind_speeds[i],
                })

        # Print results
        for date, details in forecast.items():
            print(f"\n📅 Date: {date}")
            for entry in details:
                print(f"  ⏰ Time: {entry['time']}")
                print(f"    🌡️ Temperature: {entry['temperature']}°C")
                print(f"    💨 Wind Speed: {entry['wind_speed']} m/s")
                print(f"    🌧️ Precipitation: {entry['precipitation']} mm")
                print(f"    ☁️ Condition: {entry['weather']}\n")

        # Return the response to the frontend
        return {"forecast": forecast}



    else:
        print("Error fetching forecast. Check your coordinates.")

if __name__ == "__main__":
    lat = float(input("Enter latitude: "))
    lon = float(input("Enter longitude: "))
    
    get_weather_forecast(lat, lon, days=3)
