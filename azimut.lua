local date = require("date")

local _M = {}

local azimut,altitude,w,e,m,ecliptic,Ee,longt,RA,DEC,GMST0,SIDTIME,HA

local pi = 3.14159265358979323846 
local rad_deg = 180.0/pi
local deg_rad = pi/180.0

local function cir(x)
	return x - math.floor (x / 360.0) * 360.0;
end

local function days(utc)
	utc = date(utc) or date():toutc()
	local d = date.diff(utc, date(2000, 1, 1))
	local UT = (d:gethours()+(d:getminutes()/60))/24
	return math.floor(d:spandays())+UT,UT
end

local function solar(utc,lat,lon)
	local days,UT = days(utc)
	w = 282.9404 + 0.0000470935*days    -- долгота перигелия
	e = 0.016709-0.000000001151*days     --эксцентриситет орбиты
	m = cir(356.0470 + 0.9856002585*days)    --средняя аномалия
	ecliptic = 23.4393-0.0000003563*days -- наклон плоскости эклиптики	
	Ee = m+(180.0/pi)*e*math.sin(m*deg_rad)*(1+e*math.cos(m*deg_rad)) --эксцентрическая аномалия
	local L = cir(w+m)	
	local x = math.cos(Ee*deg_rad)-e
	local y = math.sin(Ee*deg_rad)*math.sqrt(1-e*e)
	local r = math.sqrt(x*x+y*y)
	local v = math.atan2(y,x)*rad_deg
	longt = cir(v+w) --эклиптическая долгота Солнца 
	local x = r*math.cos(longt*deg_rad)
	local y = r*math.sin(longt*deg_rad)
	local z = 0.0
	local xequat = x
	local yequat = y*math.cos(deg_rad*ecliptic)-z*math.sin(deg_rad*ecliptic)
	local zequat = y*math.sin(deg_rad*ecliptic)+z*math.cos(deg_rad*ecliptic)
	-- экваториальные координаты Солнца
	RA  = math.atan2(yequat,xequat)*rad_deg -- прямое восхождение
	DEC = math.asin(zequat/r)*rad_deg -- склонение
	--расчет азимутальных координат 
	GMST0=L/15.0+12.0 -- звездное время для гринвичского меридиана 
	SIDTIME = GMST0+UT+lon/15.0   -- Звездное время
	if SIDTIME<0 then SIDTIME = SIDTIME+24.0 end
	if SIDTIME>24 then SIDTIME = SIDTIME-24.0 end
	HA = SIDTIME*15.0-RA --Часовой угол
	local xx = math.cos(HA*deg_rad)*math.cos(DEC*deg_rad)
	local yy = math.sin(HA*deg_rad)*math.cos(DEC*deg_rad)
	local zz = math.sin(DEC*deg_rad)
	local Xhor = xx*math.sin(lat*deg_rad)-zz*math.cos(lat*deg_rad)
	local Yhor=yy;
	local Zhor=xx*math.cos(lat*deg_rad)+zz*math.sin(lat*deg_rad)
	azimut = math.atan2(Yhor,Xhor)*rad_deg+180 -- азимут Солнца [град]
	altitude = math.asin(Zhor)*rad_deg -- высота Солнца над горизонтом [град]
end

function _M.get(utc,lat,lon)
	solar(utc,lat,lon)
	return azimut,altitude
end

function _M.data(utc,lat,lon)
	solar(utc,lat,lon)
	return {
		['azimut'] = azimut, -- Sun azimuth [deg]
		['altitude'] = altitude,-- Sun's altitude above the horizon [deg]
		['perihelion_lon'] = w, -- Longitude of perihelion
		['eccentricity'] = e, -- Orbital eccentricity		
		['anomaly'] = m, -- Average anomaly
		['ecliptic_angle'] = ecliptic, -- Obliquity of the ecliptic plane
		['eccentric'] = Ee, -- Eccentric anomaly
		['ecliptic_lon'] = longt, -- Sun's Ecliptic longitude
		['ascension'] = RA, -- Equatorial coordinates of the Sun: right ascension
		['declination'] = DEC,  -- Equatorial coordinates of the Sun: declination
		['sidereal_time_utc'] = GMST0, -- Greenwich's sidereal time
		['sidereal_time_local'] = SIDTIME, -- Point sidereal time
		['hour_angle'] = HA -- Sun hour angle
	}
end

return _M


