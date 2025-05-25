local azimut = require('azimut')
local json = require('cjson')

print(azimut.get(nil,54.5,54.2))

print(json.encode(azimut.data(nil,54.5,54.2)))
