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
    }
}

local fecha_mantto = {
    dia = 21,
    mes = 09,
    ano = 2026
}

f.variables = {
    caratula = {
        edificio = "Art 28",
        nro_informe = 51
    },
    fecha = fecha_mantto,
    descripcion = {
        estaciones = "so",
        sotano = {
            ubicacion = "Sótano",
            marca = marcas.sara.name,
            modelo = marcas.sara.equi,
            tecnologia = tecnologias.FBA,
            serie = 6876
        },
        azotea = {
            ubicacion = "Azotea",
            marca = marcas.sara.name,
            modelo = marcas.sara.equi,
            tecnologia = tecnologias.FBA,
            serie = 7196
        }
    },
    disponibilidad = {
        sotano = {
            station = "ED",
            code = "MF38N",
            location = "00",
            inicio = { -- inicio de los datos
                dia = 25,
                mes = 04,
                ano = 2025
            },
            final = fecha_mantto,
            tamano = 15.0,
            ext_tam = "GB",
            archivos = 37071,
            carpetas = 0,
            dispone = 100
        },
        azotea = {
            station = "ED",
            code = "ELA2",
            location = "00",
            inicio = {
                dia = 24,
                mes = 08,
                ano = 2026
            },
            final = fecha_mantto,
            tamano = 1.1,
            ext_tam = "MB",
            archivos = 27,
            carpetas = 0,
            dispone = 93
        }
    },
    suministro = {
        sotano = {
            fuente = {
                marca = marcas.mean.name,
                modelo = marcas.mean.mode_dice,
                capacidad = marcas.mean.capa_dice,
                vin = 220.9,
                vout = 13.4,
                areg = 0.1
            },
            controlador = {
                marca = marcas.morning.name,
                modelo = marcas.morning.mode_dice,
                capacidad = marcas.morning.capa_dice,
                vin = 13.4,
                vbat = 13.4,
                vcar = 13.4
            },
            bateria = {
                marca = "RITAR",
                modelo = "RT12120(12VDC/12Ah)",
                arreglo = "paralelo",
                capacidad = "12V/24Ah",
                vini = 13.3, -- 13 05
                tdes = 20,
                vfin = 12.6 -- 13 25
            }
        },
        azotea = {
            fuente = {
                vin = 220.4,
                vout = 13.57,
                areg = 0.07
            },
            controlador = {
                vin = 13.56,
                vbat = 13.56,
                vcar = 13.55
            },
            bateria = {
                vini = 13.44, --15 01
                tdes = 36,
                vfin = 12.86 -- 15 37
            }
        }
    },
    sensor = {
        onda = {"Cuadrada"},
        sotano = {
            offset = {
                antes = {
                    chz = {
                        max = 9192,
                        min = 8794,
                        ext = "cts"
                    },
                    chn = {
                        max = -35905,
                        min = -36215,
                        ext = "cts"
                    },
                    che = {
                        max = -47914,
                        min = -48266,
                        ext = "cts"
                    }
                },
                despues = {
                    chz = {
                        max = 136,
                        min = -114,
                        ext = "cts"
                    },
                    chn = {
                        max = 66,
                        min = -164,
                        ext = "cts"
                    },
                    che = {
                        max = 126,
                        min = -205,
                        ext = "cts"
                    }
                }
            },
            eficaz = {
                antes = {
                    chz = 398,
                    chn = 310,
                    che = 352
                },
                despues = {
                    chz = 250,
                    chn = 230,
                    che = 331
                },
                extension = "cts"
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 1702758.71,
                        min = 10884.52
                    },
                    aceleracion = {
                        amp = 391.532
                    }
                },
                norte = {
                    cuentas = {
                        max = 1644242.95,
                        min = -30294.02
                    },
                    aceleracion = {
                        amp = 391.494
                    }
                },
                este = {
                    cuentas = {
                        max = 1629448.97,
                        min = -49304.64
                    },
                    aceleracion = {
                        amp = 392.480
                    }
                }
            }
        },
        azotea = {
            offset = {
                antes = {
                    chz = {
                        max = -53624,
                        min = -55228,
                        ext = "cts"
                    },
                    chn = {
                        max = -26926,
                        min = -28122,
                        ext = "cts"
                    },
                    che = {
                        max = -10530,
                        min = -11734,
                        ext = "cts"
                    }
                },
                despues = {
                    chz = {
                        max = 636,
                        min = -850,
                        ext = "cts"
                    },
                    chn = {
                        max = 560,
                        min = -548,
                        ext = "cts"
                    },
                    che = {
                        max = 571,
                        min = -533,
                        ext = "cts"
                    }
                }
            },
            eficaz = {
                antes = {
                    chz = 1604,
                    chn = 1196,
                    che = 1204
                },
                despues = {
                    chz = 1486,
                    chn = 1108,
                    che = 1104
                },
                extension = "cts"
            },
            calibracion = {
                vertical = {
                    cuentas = {
                        max = 1761699,
                        min = -129931
                    },
                    aceleracion = {
                        amp = 783.6
                    }
                },
                norte = {
                    cuentas = {
                        max = 1790579,
                        min = -103794
                    },
                    aceleracion = {
                        amp = 776.66
                    }
                },
                este = {
                    cuentas = {
                        max = 1809949,
                        min = -85673
                    },
                    aceleracion = {
                        amp = 791.98
                    }
                }
            }
        }
    },
    dispositivos = {
        sotano = {
            interna = {
                memoria = memorias.uno,
                libre = 15508.41,
                total = 15566.01,
                extension = "MB"
            },
            externa = {
                memoria = memorias.dos,
                libre = 43847.51,
                total = 60045.52,
                extension = "MB"
            }
        },
        azotea = {
            interna = {
                memoria = memorias.uno,
                libre = 7766.59,
                total = 7786.64,
                extension = "MB"
            },
            externa = {
                memoria = memorias.dos,
                libre = 0,
                total = 0,
                extension = "MB"
            }
        }
    },
    sistema = {
        sotano = {
            incertidumbre = "-",
            satelites = 5,
            latitud = 12.127997,
            longitud = 77.025672,
            altitud = 147.0
        },
        azotea = {
            incertidumbre = "NA",
            satelites = 14,
            latitud = 12.081928,
            longitud = 77.025810,
            altitud = 241.2
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
