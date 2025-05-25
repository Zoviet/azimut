# Sun's azimuth calc

## Using

Get the sun azimuth [deg] and altitude above the horizon [deg]:

```
local azimut = require('azimut')

date = '2025-01-03 14:55:55' -- UTC time or datetime with offset

azumut, altitude = azimut.get(date,54.5,54.2)

```
Get the full data:

```
local azimut = require('azimut')

date = '2025-01-03 14:55:55' -- UTC time or datetime with offset

data = azimut.data(date,54.5,54.2)

```

Where:

- azimut - Sun azimuth [deg]
- altitude - Sun's altitude above the horizon [deg]
- perihelion_lon - Longitude of perihelion
- eccentricity - Orbital eccentricity		
- anomaly - Average anomaly
- ecliptic_angle - Obliquity of the ecliptic plane
- eccentric - Eccentric anomaly
- ecliptic_lon - Sun's Ecliptic longitude
- ascension - Equatorial coordinates of the Sun: right ascension
- declination - Equatorial coordinates of the Sun: declination
- sidereal_time_utc - Greenwich's sidereal time
- sidereal_time_local - Point sidereal time
- hour_angle - Sun hour angle
