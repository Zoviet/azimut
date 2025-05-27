local date = require("date")

local _M = {}

local azimut,altitude,w,e,m,ecliptic,Ee,longt,RA,DEC,GMST0,SIDTIME,HA

local rad = math.rad
local deg = math.deg
local floor = math.floor
local cir = function(x) return x - math.floor (x / 360.0) * 360.0 end
local cos = function(d) return math.cos(rad(d)) end
local acos = function(d) return deg(math.acos(d)) end
local sin = function(d) return math.sin(rad(d)) end
local asin = function(d) return deg(math.asin(d)) end
local tan = function(d) return math.tan(rad(d)) end
local atan = function(d) return deg(math.atan(rad(d))) end
local atan2 = function(x,y) return deg(math.atan2(rad(x),rad(y))) end

local function days(utc)
	utc = date(utc) or date():toutc()
	local d = date.diff(utc, date(2000, 1, 1))
	local UT = utc:gethours()+(utc:getminutes()/60)
	return floor(d:spandays())+UT/24,UT
end

local function solar(utc,lat,lon)
	local days,UT = days(utc)
	w = 282.9404 + 0.0000470935*days    -- долгота перигелия
	e = 0.016709-0.000000001151*days     --эксцентриситет орбиты
	m = cir(356.0470 + 0.9856002585*days)    --средняя аномалия
	ecliptic = 23.4393-0.0000003563*days -- наклон плоскости эклиптики	
	Ee = m+e*sin(m)*(1+e*cos(m)) --эксцентрическая аномалия	
	local L = cir(w+m) 
	local x = cos(Ee)-e
	local y = sin(Ee)*math.sqrt(1-e*e)
	local r = math.sqrt(x*x+y*y)
	local v = atan2(y,x)
	longt = cir(v+w) --эклиптическая долгота Солнца 
	local x = r*cos(longt)
	local y = r*sin(longt)
	local z = 0 
	local xequat = x
	local yequat = y*cos(ecliptic)-z*sin(ecliptic)
	local zequat = y*sin(ecliptic)+z*cos(ecliptic)
	-- экваториальные координаты Солнца
	RA  = atan2(yequat,xequat)-- прямое восхождение
	DEC = asin(zequat/r) -- склонение
	--расчет азимутальных координат 
	GMST0=L/15.0+12.0 -- звездное время для гринвичского меридиана 
	SIDTIME = GMST0+UT+lon/15.0   -- Звездное время
	if SIDTIME<0 then SIDTIME = SIDTIME+24.0 end
	if SIDTIME>24 then SIDTIME = SIDTIME-24.0 end
	HA = SIDTIME*15.0-RA --Часовой угол
	local xx = cos(HA)*cos(DEC)
	local yy = sin(HA)*cos(DEC)
	local zz = sin(DEC)
	local Xhor = xx*sin(lat)-zz*cos(lat)
	local Yhor=yy;
	local Zhor=xx*cos(lat)+zz*sin(lat)
	azimut = atan2(Yhor,Xhor)+180 -- азимут Солнца [град]
	altitude = asin(Zhor) -- высота Солнца над горизонтом [град]
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


