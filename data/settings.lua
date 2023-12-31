return {
    zone = {
        points = {
            vec3(1841.0, 2612.0, 46.0),
            vec3(1827.0, 2612.0, 46.0),
            vec3(1827.0, 2604.0, 46.0),
            vec3(1841.0, 2604.0, 46.0),
        },
        thickness = 4.0,
        debug = true
    },
    maxJailTime = 30,
    coordinates = {
        insideJail = vec4(1691.2992, 2564.3391, 45.5648, 177.1720),
        outsideJail = vec4(1848.5389, 2585.9131, 45.6720, 266.7117)
    },
    command = {
        use = true,
        name = 'jailtime'
    },
    locales = {
        ['notify'] = {
            ['title'] = 'Staate Prison',
            ['time_remaining'] = 'You have to stay for %s minutes.'
        }
    }
}