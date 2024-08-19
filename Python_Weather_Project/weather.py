# Temp in C° or F°

# import requests
# try:
# response = requests.get("https://api.openweathermap.org/data/2.5/weather?units=metric&lat=55.7735&lon=-3.9194&appid=d6b8734b61393f2900fb24b55a6104f6")

# except:
# print("No internet access :(")

# response_json = response.json()

# temp = response_json["main"]["temp"]
# temp_min = response_json["main"]["temp_min"]
# temp_max = response_json["main"]["temp_max"]
# location = response_json["name"]

# print(f"In {location} it is currently {temp}°C.")
# print(f"Today's high is {temp_max}°C")
# print(f"Today's low is {temp_min}°C")


# Create class which will help get temperature information for any city

import requests


class City:
    def __init__(self, name, lat, lon, units="metric"):
        self.name = name
        self.lat = lat
        self.lon = lon
        self.units = units
        self.get_data()

    def get_data(self):
        try:
            response = requests.get(
                f"https://api.openweathermap.org/data/2.5/weather?units={self.units}&lat={self.lat}&lon={self.lon}&appid=d6b8734b61393f2900fb24b55a6104f6")
        except:
            print("No internet access :(")

        self.response_json = response.json()
        self.name = self.response_json["name"]
        self.temp = self.response_json["main"]["temp"]
        self.temp_min = self.response_json["main"]["temp_min"]
        self.temp_max = self.response_json["main"]["temp_max"]

    def temp_print(self):
        units_symbol = "C"
        if self.units == "imperial":
            units_symbol = "F"

        print(f"In {self.name} it is currently {self.temp}° {units_symbol}.")
        print(f"Today's high is {self.temp_max}° {units_symbol}")
        print(f"Today's low is {self.temp_min}° {units_symbol}")


# C- "metric" / F- "imperial"
wishaw = City("", 55.7735, -3.9194, units="metric")
wishaw.temp_print()

cartaxo = City("", 39.1618, -8.7888, units="metric")
cartaxo.temp_print()

santarem = City("", 39.23333, -8.68333, units="metric")
santarem.temp_print()
