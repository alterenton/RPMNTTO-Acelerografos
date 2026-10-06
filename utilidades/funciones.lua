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
        web = "https://kinemetrics.com/"
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
        mode = "RT12120 (12V/12Ah)"
    }
}

local fecha_mantto = {
    dia = 21,
    mes = 09,
    ano = 2026
}

f.variables = {
    caratula = {
        edificio = "Torre del Parque I",
        nro_informe = 52
    },
    fecha = fecha_mantto,
    descripcion = {
        estaciones = "soaz",
        sotano = {
            ubicacion = "Sótano",
            marca = marcas.nano.name,
            modelo = marcas.nano.equi,
            tecnologia = tecnologias.FBA,
            serie = 1068
        },
        azotea = {
            ubicacion = "Azotea",
            marca = marcas.nano.name,
            modelo = marcas.nano.equi,
            tecnologia = tecnologias.FBA,
            serie = 2296
        }
    },
    disponibilidad = {
        sotano = {
            station = "PE",
            code = "SI30N",
            location = "01",
            inicio = { -- inicio de los datos
                dia = 08,
                mes = 01,
                ano = 2026
            },
            final = fecha_mantto,
            tamano = 8.5,
            ext_tam = "GB",
            archivos = 18446,
            carpetas = 271,
            dispone = 100
        },
        azotea = {
            station = "ED",
            code = "SI71N",
            location = "",
            inicio = {
                dia = 25,
                mes = 09,
                ano = 2025
            },
            final = fecha_mantto,
            tamano = 19.3,
            ext_tam = "GB",
            archivos = 26004,
            carpetas = 377,
            dispone = 100
        }
    },
    suministro = {
        sotano = {
            fuente = {
                marca = marcas.mean.name,
                modelo = marcas.mean.mode_dice,
                capacidad = marcas.mean.capa_dice,
                vin = 226.3,
                vout = 13.03,
                areg = 0.47
            },
            controlador = {
                marca = marcas.morning.name,
                modelo = marcas.morning.mode_dice,
                capacidad = marcas.morning.capa_dice,
                vin = 13.02,
                vbat = 13.01,
                vcar = 13.01
            },
            bateria = {
                marca = marcas.ritar.name,
                modelo = marcas.ritar.mode,
                arreglo = "",
                capacidad = "",
                vini = 12.91, -- 13 49
                tdes = 37,
                vfin = 12.4 -- 14 26
            }
        },
        azotea = {
            fuente = {
                marca = marcas.mean.name,
                modelo = marcas.mean.mode_dice,
                capacidad = marcas.mean.capa_dice,
                vin = 230.6,
                vout = 13.57,
                areg = 0.07
            },
            controlador = {
                marca = marcas.morning.name,
                modelo = marcas.morning.mode_dice,
                capacidad = marcas.morning.capa_dice,
                vin = 13.57,
                vbat = 13.57,
                vcar = 13.56
            },
            bateria = {
                vini = 13.51, --14 54
                tdes = 41,
                vfin = 12.82 -- 15 35
            }
        }
    },
    sensor = {
        onda = {"Senoidal"},
        sotano = {
            offset = {
                antes = {
                    chz = {
                        max = -4.649,
                        min = -4.989,
                        ext = "mg"
                    },
                    chn = {
                        max = 10.55,
                        min = 10.45,
                        ext = "mg"
                    },
                    che = {
                        max = 1.065,
                        min = 0.916,
                        ext = "mg"
                    }
                },
                despues = {
                    chz = {
                        max = 73.00,
                        min = -74.00,
                        ext = "ug"
                    },
                    chn = {
                        max = 35.50,
                        min = -35.50,
                        ext = "ug"
                    },
                    che = {
                        max = 43.50,
                        min = -42.50,
                        ext = "ug"
                    }
                }
            },
            eficaz = {
                extension = "ug",
                antes = {
                    chz = 63.83,
                    chn = 14.90,
                    che = 15.97
                },
                despues = {
                    chz = 21.40,
                    chn = 8.762,
                    che = 10.71
                }
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 833183,
                        min = -847649
                    },
                    aceleracion = {
                        amp = 411.996
                    }
                },
                norte = {
                    cuentas = {
                        max = 856550,
                        min = -871331
                    },
                    aceleracion = {
                        amp = 423.525
                    }
                },
                este = {
                    cuentas = {
                        max = 850245,
                        min = -864902
                    },
                    aceleracion = {
                        amp = 420.403
                    }
                }
            }
        },
        azotea = {
            offset = {
                antes = {
                    chz = {
                        max = -2.125,
                        min = -5.008,
                        ext = "mg"
                    },
                    chn = {
                        max = 15.48,
                        min = 14.72,
                        ext = "mg"
                    },
                    che = {
                        max = 10.02,
                        min = 9.045,
                        ext = "mg"
                    }
                },
                despues = {
                    chz = {
                        max = 1.495,
                        min = -1.279,
                        ext = "mg"
                    },
                    chn = {
                        max = 390.5,
                        min = -364.5,
                        ext = "ug"
                    },
                    che = {
                        max = 428.5,
                        min = -491.5,
                        ext = "ug"
                    }
                }
            },
            eficaz = {
                extension = "ug",
                antes = {
                    chz = 425.0,
                    chn = 112.3,
                    che = 134.1
                },
                despues = {
                    chz = 432.1,
                    chn = 113.0,
                    che = 137.3
                }
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 894092,
                        min = -865644
                    },
                    aceleracion = {
                        amp = 431.313
                    }
                },
                norte = {
                    cuentas = {
                        max = 845528,
                        min = -818320
                    },
                    aceleracion = {
                        amp = 407.847
                    }
                },
                este = {
                    cuentas = {
                        max = 882810,
                        min = -854498
                    },
                    aceleracion = {
                        amp = 425.825
                    }
                }
            }
        }
    },
    dispositivos = {
        sotano = {
            interna = {
                memoria = memorias.uno,
                libre = 5.6,
                total = 5.6,
                extension = "GB"
            },
            externa = {
                memoria = memorias.tres,
                libre = 20.272,
                total = 28.961,
                extension = "GB"
            }
        },
        azotea = {
            interna = {
                memoria = memorias.uno,
                libre = 7.4,
                total = 7.4,
                extension = "GB"
            },
            externa = {
                memoria = memorias.tres,
                libre = 8.9,
                total = 29.0,
                extension = "GB"
            }
        }
    },
    sistema = {
        sotano = {
            incertidumbre = "0.10",
            satelites = 5,
            latitud = 12.092738,
            longitud = 77.024999,
            altitud = 184
        },
        azotea = {
            incertidumbre = "0.10",
            satelites = 11,
            latitud = 12.093220,
            longitud = 77.025009,
            altitud = 225
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
