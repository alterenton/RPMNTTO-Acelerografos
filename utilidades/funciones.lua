local f = {}

local memorias = {
    uno = "eMMC",
    dos = "USB Flash Drive",
    tres = "SD Card",
    cuatro = "microSD"
}

local tecnologias = {
    MEMS = "Sistemas MicroElectroMecánicos (MEMS)",
    FBA = "Acelerómetros de Fuerza Balanceada (FBA)"
}

local marcas = {
    luni = {
        name = "LUNITEK Seismic Recorders Manufacturer",
        web = "https://lunitek.com/"
    },
    sara = {
        name = "SARA Electronic Instruments",
        web = "https://www.sara.pg.it/index.php?lang=en",
        equi = "AceBox"
    },
    nano = {
        name = "NANOMETRICS Listening to the Earth",
        web = "https://nanometrics.ca/home",
        equi = "TitanSMA"
    },
    kine = {
        name = "KINEMETRICS Advancement Through Innovation",
        web = "https://kinemetrics.com/",
        equi = "Etna2"
    },
    mean = {
        name = "MW Mean Well",
        web = "https://www.meanwell.com/",
        mode = "LRS Series",
        capa = "10A@12V"
    },
    morning = {
        name = "Morningstar Corp.",
        web = "https://www.morningstarcorp.com/",
        mode = "SHS-10",
        capa = "10A@12V"
    },
    victron = {
        name = "Victron Energy",
        web = "https://www.victronenergy.com/",
        mode = "Blue Solar PWM - Light",
        capa = "20A@24V"
    },
    ritar = {
        name = "RITAR",
        web = "https://www.ritarpower.com/",
        mode = "RT12120",
        capa = "12V / 12Ah"
    },
    samlex = {
        name = "Samlex",
        web = "https://samlex.com/",
        mode = "SEC-1230UL",
        capa = "12V, 30A"

    }
}

local fecha_mantto = {
    dia = 07,
    mes = 10,
    ano = 2026
}

f.variables = {
    caratula = {
        edificio = "America TV",
        nro_informe = 57
    },
    fecha = fecha_mantto,
    descripcion = {
        estaciones = "so",
        sotano = {
            ubicacion = "Sótano",
            marca = marcas.sara.name,
            modelo = marcas.sara.equi,
            tecnologia = tecnologias.FBA,
            serie = 6879
        },
        azotea = {
            ubicacion = "Azotea",
            marca = marcas.sara.name,
            modelo = marcas.sara.equi,
            tecnologia = tecnologias.FBA,
            serie = 8653
        }
    },
    disponibilidad = {
        sotano = {
            station = "ED",
            code = "LI14N",
            location = "00",
            inicio = {
                dia = 31,
                mes = 03,
                ano = 2026
            },
            final = {
                dia = 07,
                mes = 10,
                ano = 2026
            },
            tamano = 5.65,
            ext_tam = "GB",
            archivos = 13710,
            carpetas = 0,
            dispone = 100
        },
        azotea = {
            station = "ED",
            code = "JM61N",
            location = "",
            inicio = {
                dia = 23,
                mes = 04,
                ano = 2026
            },
            final = fecha_mantto,
            tamano = 4.71,
            ext_tam = "GB",
            archivos = 8310,
            carpetas = 0,
            dispone = 69.8
        }
    },
    suministro = {
        sotano = {
            fuente = {
                marca = marcas.mean.name,
                modelo = marcas.mean.mode,
                capacidad = marcas.mean.capa,
                vin = 233.2,
                vout = 13.7,
                areg = 0.2
            },
            controlador = {
                marca = marcas.morning.name,
                modelo = marcas.morning.mode,
                capacidad = marcas.morning.capa,
                vin = 13.7,
                vbat = 13.7,
                vcar = 13.7
            },
            bateria = {
                marca = marcas.ritar.name,
                modelo = marcas.ritar.mode,
                arreglo = "paralelo",
                nro_bat = 2,
                capa_tota = "12V / 24Ah",
                vini = 13.7, -- 11:25
                tdes = 13,
                vfin = 12.9 -- 11:38
            }
        },
        azotea = {
            fuente = {
                marca = marcas.mean.name,
                modelo = marcas.mean.mode_dice,
                capacidad = marcas.mean.capa_dice,
                vin = 229.6,
                vout = 13.7,
                areg = 0.2
            },
            controlador = {
                marca = marcas.morning.name,
                modelo = marcas.morning.mode_dice,
                capacidad = marcas.morning.capa_dice,
                vin = 13.7,
                vbat = 13.7,
                vcar = 13.7
            },
            bateria = {
                marca = marcas.ritar.name,
                modelo = marcas.ritar.mode,
                arreglo = "paralelo",
                capa_tota = "24V / 12Ah",
                vini = 13.6, --16.42,
                tdes = 15,
                vfin = 13.2 -- 16.57
            }
        }
    },
    sensor = {
        onda = "Cuadrada",
        sotano = {
            offset = {
                antes = {
                    chz = {
                        max = 8564,
                        min = 8234,
                        ext = "cts"
                    },
                    chn = {
                        max = -19230,
                        min = -19464,
                        ext = "cts"
                    },
                    che = {
                        max = -24977,
                        min = -25165,
                        ext = "cts"
                    }
                },
                despues = {
                    chz = {
                        max = 157,
                        min = -145,
                        ext = "cts"
                    },
                    chn = {
                        max = 140,
                        min = -157,
                        ext = "cts"
                    },
                    che = {
                        max = 119,
                        min = -135,
                        ext = "cts"
                    }
                }
            },
            eficaz = {
                extension = "cts",
                antes = {
                    chz = 330,
                    chn = 234,
                    che = 188
                },
                despues = {
                    chz = 302,
                    chn = 297,
                    che = 254
                }
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 1681622.76,
                        min = 26772.88
                    },
                    aceleracion = {
                        amp = 388.907
                    }
                },
                norte = {
                    cuentas = {
                        max = 1667398.18,
                        min = -3938.91
                    },
                    aceleracion = {
                        amp = 386.971
                    }
                },
                este = {
                    cuentas = {
                        max = 1654888.68,
                        min = -9823.69
                    },
                    aceleracion = {
                        amp = 391.087
                    }
                }
            }
        },
        azotea = {
            offset = {
                antes = {
                    chz = {
                        max = 1652594,
                        min = 1651129,
                        ext = "cts"
                    },
                    chn = {
                        max = 15305,
                        min = 14187,
                        ext = "cts"
                    },
                    che = {
                        max = -6831,
                        min = -7911,
                        ext = "cts"
                    }
                },
                despues = {
                    chz = {
                        max = 1077,
                        min = -700,
                        ext = "cts"
                    },
                    chn = {
                        max = 554,
                        min = -524,
                        ext = "cts"
                    },
                    che = {
                        max = 532,
                        min = -553,
                        ext = "cts"
                    }
                }
            },
            eficaz = {
                extension = "cts",
                antes = {
                    chz = 1465,
                    chn = 1118,
                    che = 1080
                },
                despues = {
                    chz = 1777,
                    chn = 1078,
                    che = 1085
                }
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 1848961.01,
                        min = 1652800.52
                    },
                    aceleracion = {
                        amp = 46.101
                    }
                },
                norte = {
                    cuentas = {
                        max = 624508.81,
                        min = 13470.37
                    },
                    aceleracion = {
                        amp = 141.527
                    }
                },
                este = {
                    cuentas = {
                        max = 483095.13,
                        min = -6400.26
                    },
                    aceleracion = {
                        amp = 115.510
                    }
                }
            }
        }
    },
    dispositivos = {
        sotano = {
            interna = {
                memoria = memorias.uno,
                libre = 12498.70,
                total = 15566.01,
                extension = "MB"
            },
            externa = {
                memoria = memorias.dos,
                libre = 54830.15,
                total = 60964.53,
                extension = "MB"
            }
        },
        azotea = {
            interna = {
                memoria = memorias.uno,
                libre = 16064.87,
                total = 16079.91,
                extension = "MB"
            },
            externa = {
                memoria = memorias.dos,
                libre = 55787.45,
                total = 60889.13,
                extension = "MB"
            }
        }
    },
    sistema = {
        sotano = {
            incertidumbre = "-",
            satelites = 12,
            latitud = 12.074773,
            longitud = 77.033412,
            altitud = 174.7
        },
        azotea = {
            incertidumbre = "NA",
            satelites = 15,
            latitud = 12.082298,
            longitud = 77.049052,
            altitud = 179.6
        }
    }
}

function f.variables.fecha.muestra(fecha) -- 19/08/2026
    return string.format(
        "%02d/%02d/%04d",
        fecha.dia,
        fecha.mes,
        fecha.ano
    )
end

function f.variables.disponibilidad.codigo(estacion) -- ED.PL05N.__
    return string.format(
        "%s.%s.%s",
        f.variables.disponibilidad[estacion].station,
        f.variables.disponibilidad[estacion].code,
        f.variables.disponibilidad[estacion].location
    )
end

function f.variables.fecha.doy(fecha)
    local dias = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

    if (fecha.ano % 4 == 0 and fecha.ano % 100 ~= 0) or (fecha.ano % 400 == 0) then
        dias[2] = 29
    end

    local resultado = fecha.dia

    for i = 1, fecha.mes - 1 do
        resultado = resultado + dias[i]
    end

    local formato = fecha.ano .. resultado

    return formato
end

function f.variables.fecha.dias_entre_fechas(fecha1, fecha2)
    -- Crear la tabla de tiempo para la fecha inicial (00:00:00)
    local t1 = os.time({
        day = tonumber(fecha1.dia),
        month = tonumber(fecha1.mes),
        year = tonumber(fecha1.ano),
        hour = 0,
        min = 0,
        sec = 0
    })

    -- Crear la tabla de tiempo para la fecha final (00:00:00)
    local t2 = os.time({
        day = tonumber(fecha2.dia),
        month = tonumber(fecha2.mes),
        year = tonumber(fecha2.ano),
        hour = 0,
        min = 0,
        sec = 0
    })

    -- Diferencia en segundos dividida por los segundos de un día (24 * 60 * 60)
    local diferencia_segundos = os.difftime(t2, t1)
    local dias = math.floor(diferencia_segundos / 86400)

    return dias
end

function f.buscar_pga_maximo(archivo)
    local resultado = {
        valor = -math.huge,
        evento = nil,
        referencia = nil,
        magnitud = nil,
        hora = nil,
        pgae = nil,
        pgan = nil,
        pgaz = nil
    }

    local file = io.open(archivo, "r")

    if not file then
        error("No se pudo abrir el archivo: " .. archivo)
    end

    -- Saltar cabecera
    file:read("*l")

    for linea in file:lines() do
        local evento, referencia, magnitud, hora, pgae, pgan, pgaz =
            linea:match("([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);([^;]*);([^;]*)")

        pgae = tonumber(pgae)
        pgan = tonumber(pgan)
        pgaz = tonumber(pgaz)

        -- Máximo PGA de esta fila
        local pga = math.max(pgae, pgan, pgaz)

        -- ¿Es el mayor encontrado hasta ahora?
        if pga > resultado.valor then
            resultado.valor = pga
            resultado.evento = tonumber(evento)
            resultado.referencia = referencia
            resultado.magnitud = tonumber(magnitud)
            resultado.hora = hora

            resultado.pgae = pgae
            resultado.pgan = pgan
            resultado.pgaz = pgaz
        end
    end

    file:close()

    return resultado
end

return f
