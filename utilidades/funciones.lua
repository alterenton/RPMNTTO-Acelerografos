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
        mode_dice = "LRS Series",
        capa_dice = "10A@12V"
    },
    morning = {
        name = "Morningstar Corp.",
        web = "https://www.morningstarcorp.com/",
        mode_dice = "SHS-10",
        capa_dice = "10A@12V"
    },
    victron = {
        name = "Victron Energy",
        web = "https://www.victronenergy.com/",
        mode_dice = "Blue Solar PWM - Light",
        capa_dice = "20A@24V"
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
    dia = 02,
    mes = 10,
    ano = 2026
}

f.variables = {
    caratula = {
        edificio = "Design",
        nro_informe = 55
    },
    fecha = fecha_mantto,
    descripcion = {
        estaciones = "so",
        sotano = {
            ubicacion = "Sótano",
            marca = marcas.kine.name,
            modelo = marcas.kine.equi,
            tecnologia = tecnologias.FBA,
            serie = 102955
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
            station = "kmi",
            code = "kmi",
            location = "",
            inicio = {
                dia = 08,
                mes = 06,
                ano = 2020
            },
            final = {
                dia = 16,
                mes = 10,
                ano = 2022
            },
            tamano = 27.3,
            ext_tam = "GB",
            archivos = 62772,
            carpetas = 0,
            dispone = 99.2
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
                marca = marcas.samlex.name,
                modelo = marcas.samlex.mode,
                capacidad = marcas.samlex.capa,
                vin = 226.9,
                vout = 13.5,
                areg = 0.0
            },
            controlador = {
                marca = marcas.samlex.name,
                modelo = marcas.samlex.mode,
                capacidad = marcas.samlex.capa,
                vin = 13.5,
                vbat = 13.5,
                vcar = 13.5
            },
            bateria = {
                marca = "Plomo Ácido",
                modelo = "AGM",
                arreglo = "Front Terminal",
                nro_bat = 1,
                capa_tota = "12V 30Ah",
                vini = 13.2, -- 11 31
                tdes = 184,
                vfin = 12.6, --14 35
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
        onda = "Interna",
        sotano = {
            offset = {
                antes = {
                    chz = {
                        max = -70634,
                        min = -70723,
                        ext = "cts"
                    },
                    chn = {
                        max = -31594,
                        min = -31623,
                        ext = "cts"
                    },
                    che = {
                        max = -48634,
                        min = -48967,
                        ext = "cts"
                    }
                },
                despues = {
                    chz = {
                        max = 100,
                        min = -50,
                        ext = "cts"
                    },
                    chn = {
                        max = 100,
                        min = -100,
                        ext = "cts"
                    },
                    che = {
                        max = 100,
                        min = -200,
                        ext = "cts"
                    }
                }
            },
            eficaz = {
                extension = "cts",
                antes = {
                    chz = -70673,
                    chn = -31535,
                    che = -48685
                },
                despues = {
                    chz = 0.234,
                    chn = 0.864,
                    che = 0.325
                }
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 1,
                        min = -1
                    },
                    aceleracion = {
                        amp = 1
                    }
                },
                norte = {
                    cuentas = {
                        max = 1,
                        min = -1
                    },
                    aceleracion = {
                        amp = 1
                    }
                },
                este = {
                    cuentas = {
                        max = 1,
                        min = -1
                    },
                    aceleracion = {
                        amp = 1
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
                libre = 0.011,
                total = 29,
                extension = "GB"
            },
            externa = {
                memoria = "No aplica",
                libre = 0,
                total = 1,
                extension = "GB",
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
            incertidumbre = "",
            satelites = "",
            latitud = 12.130591,
            longitud = 77.032042,
            altitud = 88
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
