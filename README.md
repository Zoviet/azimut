# Sun's azimuth calc

The height of the Sun (altitude) is the arc of a vertical circle from the mathematical horizon to the central point of the solar disk (the angle between the plane of the mathematical horizon and the direction to the center of the Sun). The height is calculated from 0 ° to 90 °.

The azimuth of the Sun (azimut) is an arc in the plane of the mathematical horizon from the point of the north to the vertical circle of the Sun. Azimuth is calculated in the direction of the daily rotation of the celestial sphere, i.e. clockwise in the northern hemisphere and counterclockwise in the southern hemisphere, from the point of the north in the range from 0 ° to 360 °.

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
