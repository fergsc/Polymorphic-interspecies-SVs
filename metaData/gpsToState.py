#
# Create a free account at https://opencagedata.com/
# Get api key and enter it in script.
#

from opencage.geocoder import OpenCageGeocode

apiKey = ""
tsvFile = ""

geocoder = OpenCageGeocode(apiKey)

def get_state_from_gps(latitude, longitude):
    results = geocoder.reverse_geocode(latitude, longitude)
    if results:
        for result in results:
            components = result.get('components', {})
            return components.get('state_code')
    return None

with open(tsvFile, 'r') as tsv_file:
    for line in tsv_file:
        fields = line.strip().split('\t')
        latitude = fields[0]
        longitude = fields[1]
        state = get_state_from_gps(latitude, longitude)
        if state is None:
            state = get_state_from_gps("-" + latitude, longitude)
        if state:
            print(state)
        else:
            print("xxx")
