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
        print(f"In {self.name} it is currently {self.temp}° C")
        print(f"Today's High: {self.temp_max}° C")
        print(f"Today's Low: {self.temp_min}° C")


my_city = City("", 55.8617, -4.2583)
my_city.temp_print()

Other_city = City("", 55.9533, -3.1883)
Other_city.temp_print()

Naturality_city = City("", 39.23333, -8.68333)
Naturality_city.temp_print()
