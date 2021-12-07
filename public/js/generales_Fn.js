var glstCodidosValidacion = new Array();
glstCodidosValidacion["fecha"] = "^(?:(?:0?[1-9]|1\\d|2[0-8])(\\/|-)(?:0?[1-9]|1[0-2]))(\\/|-)(?:[1-9]\\d\\d\\d|\\d[1-9]\\d\\d|\\d\\d[1-9]\\d|\\d\\d\\d[1-9])$|^(?:(?:31(\\/|-)(?:0?[13578]|1[02]))|(?:(?:29|30)(\\/|-)(?:0?[1,3-9]|1[0-2])))(\\/|-)(?:[1-9]\\d\\d\\d|\d[1-9]\\d\\d|\\d\\d[1-9]\\d|\\d\\d\\d[1-9])$|^(29(\\/|-)0?2)(\\/|-)(?:(?:0[48]00|[13579][26]00|[2468][048]00)|(?:\\d\\d)?(?:0[48]|[2468][048]|[13579][26]))$";
glstCodidosValidacion["texto"] = "\\w+";
glstCodidosValidacion["numEntero"] = "^(\\+?|\\-)\\d+$";
glstCodidosValidacion["numReal"] = "^(\\+?|\\-)\\d+\\.?\\d*$";
glstCodidosValidacion["horaMilitar"] = "^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])?(:)?([0-5][0-9])$";
glstCodidosValidacion["correo"] = "^([A-Z|a-z|0-9](\.|_){0,1})+[A-Z|a-z|0-9]\@([A-Z|a-z|0-9])+((\.){0,1}[A-Z|a-z|0-9]){2}\.[a-z]{2,3}$";


// Descripción: Funcion para validar valor con expresion regular
// Parametro: sExpresionRegular --> Expresion regular
// Parametro: sValue --> Valor a comparar
function validarExpresiones(sExpresionRegular, sValue) {
    try {
        var ObjPatron = new RegExp(sExpresionRegular, "gi");
        return ObjPatron.test(sValue);
    } catch (e) {
        MostrarMensaje("error", "ERROR: validarExpresiones() [ " + e.name + " - " + e.message + " ]");
    }
}
// Función: Reemplazar caracteres
function replaceAll(sCadenaOld, sCadenaNew, sCadena) {
    return sCadena.replace(new RegExp(sCadenaOld, 'g'), sCadenaNew);
}
// Función: Reemplazar caracteres
function replaceAll2(sCadenaOld, sCadenaNew, sCadena) {
    var iIndex = 0;

    if (sCadenaOld !== "") {
        while (iIndex !== -1) {
            sCadena = sCadena.replace(sCadenaOld, sCadenaNew);
            iIndex = sCadena.indexOf(sCadenaOld);
        }
    }
    iIndex = 0;
    return sCadena;
}

// Nombre: mostrarControlesEstadisticas
// Parametro: sMensaje --> Mensaje que saldra en el alert
// Parametro: sTipo --> Indica el tipo de notificación
// Parametro: sLayout --> Posición en la que saldra la notificación
// Parametro: sLableOk --> La cadena que saldra en el boton de ok en la confirmación de la notificación
// Parametro: sLabelCancel -->La cadena que saldra en el boton de cancelar en la confirmación de la notificación
// Parametro: sNombreFuncion --> indica la función que se ejecutara despues de responser la notificación
// Parametro: objJson --> json que se mandara como parametro a la función que se ejecutara despues de la confirmación de la notificación.
// Desarrollador: Victor Alfonso Cardona Hernandez
// Función:  mostraran o ocultaran los controles en el bloque de estadisticas.
function mostrarAlertas(sMensaje, sTipo, sTitulo, sLayout, sLableOk, sLabelCancel, sNombreFuncion, objJson, sNombreFuncionCancel, objJsonCancel) {

    var sTituloNoty = (sTitulo ? sTitulo : "Tiserium");
    var objEvento = null;

    if (parent.crearNoty) {
        sMensaje = "<div style='text-align:left'> <div class='cssTitleNoty'>" + sTituloNoty + "<hr/></div>" + replaceAll("\n", "<br />", sMensaje) + "</div>";
        parent.crearNoty(sMensaje, sTipo, sLayout, sLableOk, sLabelCancel, sNombreFuncion, objJson, sNombreFuncionCancel, objJsonCancel);
    } else if (parent.parent.crearNoty) {
        sMensaje = "<div style='text-align:left'><div class='cssTitleNoty'>" + sTituloNoty + "<hr/></div>" + replaceAll("\n", "<br />", sMensaje) + "</div>";
        parent.parent.crearNoty(sMensaje, sTipo, sLayout, sLableOk, sLabelCancel, sNombreFuncion, objJson, sNombreFuncionCancel, objJsonCancel);
    }
    else if (crearNoty) {
        sMensaje = "<div style='text-align:left'><div class='cssTitleNoty'>" + sTituloNoty + "<hr/></div>" + replaceAll("\n", "<br />", sMensaje) + "</div>";
        parent.parent.crearNoty(sMensaje, sTipo, sLayout, sLableOk, sLabelCancel, sNombreFuncion, objJson, sNombreFuncionCancel, objJsonCancel);
    }
    else {
        sMensaje = replaceAll("<br />", "\n", sMensaje);
        if (sTipo === "confirm") {
            var bRespuesta = confirm(sMensaje);
            if (bRespuesta) {
                objEvento = eval(sNombreFuncion);
                if (objEvento) {
                    objEvento(objJson);
                }
            } else {
                if (sNombreFuncionCancel) {
                    objEvento = eval(sNombreFuncionCancel);
                    if (objEvento) {
                        objEvento(objJsonCancel);
                    }
                }
            }
        } else {
            alert(sMensaje);
        }
    }
}

// Descripción: Funcion para validar valor con expresion regular
// Parametro: sExpresionRegular --> Expresion regular
// Parametro: sValue --> Valor a comparar
function abrirPopUpBootstrap(objPopUp, sIdDiv, objEvento, objFuncionAntesAbrir, objFuncionDespuesAbrir, objFuncionAntesCerrar, objFuncionDespuesCerrar) {
    if (objPopUp === null) {
        if (objFuncionAntesAbrir) {
            $('#' + sIdDiv).on('show.bs.modal', objFuncionAntesAbrir);
        }

        if (objFuncionDespuesAbrir) {
            $('#' + sIdDiv).on('shown.bs.modal', objFuncionDespuesAbrir);
        }

        if (objFuncionAntesCerrar) {
            $('#' + sIdDiv).on('hide.bs.modal', objFuncionAntesCerrar);
        }

        if (objFuncionDespuesCerrar) {
            $('#' + sIdDiv).on('hidden.bs.modal', function () {
                objFuncionDespuesCerrar();
                //parent.$("html").css("overflow", "auto");
            });
        }

        objPopUp = $('#' + sIdDiv).modal({
            backdrop: "static",
            keyboard: true
        });
    } else {
        $(objPopUp).modal('show');
    }


    if (parent.document.getElementById("iframe_BoxJob") !== null) {
        var objPosicion = $(objEvento).position();
        var iTop = 0;

        if ((objPosicion.top - 300) > 0) {
            iTop = objPosicion.top - 300
        } else {
            iTop = objPosicion.top;
        }
        $('#' + sIdDiv).css("top", iTop + "px");
        $('#' + sIdDiv).css("overflow-y", "hidden");
        $('#' + sIdDiv).css("overflow-X", "hidden");
        //hacemos que el scroll se ubique
        moverScroll(iTop);

    } else {
        $('#' + sIdDiv).css("overflow-y", "auto");
        $('#' + sIdDiv).css("top", "0");
    }

    return objPopUp;
}

function crearComboBuscador(sIdControl, objJson, sPlaceholder, fTemplate) {
    if ($("#" + sIdControl).hasClass("select2-hidden-accessible")) {
        $("#" + sIdControl).select2("destroy");
        $("#" + sIdControl).find("option").remove();
    }
    if (objJson && objJson !== null && objJson.length > 0) {
        $("#" + sIdControl).select2({
            placeholder: (sPlaceholder ? sPlaceholder : "Seleccione...")
            , allowClear: true
            , data: objJson
            , language: "es"
            , templateResult: fTemplate

        });
        if (objJson.length === 1) {
            $("#" + sIdControl).val(objJson[0].id).trigger("change");
        } else {
            $("#" + sIdControl).select2("val", "");
        }
    } else {
        $("#" + sIdControl).select2({
            placeholder: (sPlaceholder ? sPlaceholder : "Seleccione...")
            , allowClear: true
            , language: "es"
        });
    }
}

// Parametro: sMensaje --> Mensaje que saldra en el alert
// Parametro: sTipo --> Indica el tipo de notificación
// Parametro: sLayout --> Posición en la que saldra la notificación
// Parametro: sLableOk --> La cadena que saldra en el boton de ok en la confirmación de la notificación
// Parametro: sLabelCancel -->La cadena que saldra en el boton de cancelar en la confirmación de la notificación
// Parametro: sNombreFuncion --> indica la función que se ejecutara despues de responser la notificación
// Parametro: objJson --> json que se mandara como parametro a la función que se ejecutara despues de la confirmación de la notificación.
// Desarrollador: Victor Alfonso Cardona Herandez
// Función:  mostraran o ocultaran los controles en el bloque de estadisticas.
function crearNoty(sMensaje, sTipo, sLayout, sLabelOk, sLabelCancel, sNombreFuncion, objJsonParametro, bModal) {
    noty({
        text: sMensaje // Testo que se mostrara en el mensaje
        , layout: sLayout ? sLayout : 'topRight'// ubicación en la ventana
        , type: sTipo ? sTipo : "warning"//'success' //Tipo de alert 
        , nombreFuncion: sNombreFuncion //para Evento de confirmacion
        , objJsonParametro: objJsonParametro
        , modal: (bModal ? bModal : ((sTipo !== 'confirm') ? false : true))
        , buttons: (sTipo != 'confirm') ? false : [
            {
                addClass: 'btn btn-success', text: sLabelOk ? sLabelOk : 'Aceptar', onClick: function ($noty) {
                    $noty.close();
                    //pagina dentro area de trabajo
                    try {
                        var objIframe = document.getElementById("iframe_AreaTrabajo");
                        if (objIframe !== null) {
                            var objEvento = eval('document.getElementById("' + objIframe.id + '").contentWindow.' + $noty.options.nombreFuncion);
                            if (objEvento !== null && objEvento) {
                                objEvento($noty.options.objJsonParametro);
                                return;
                            }
                        }
                    } catch (e) {

                        sMensaje = e.message;

                    }
                    try {
                        //pagina area de trabajo
                        objEvento = eval($noty.options.nombreFuncion);
                        if (objEvento !== null && objEvento) {
                            objEvento($noty.options.objJsonParametro);
                        }
                    } catch (e) {

                        sMensaje = e.message;

                    }

                    if (sMensaje) {

                        alert(sMensaje)

                    }

                }
            },
            {
                addClass: 'btn btn-warning', text: sLabelCancel ? sLabelCancel : 'Cancelar', onClick: function ($noty) {
                    $noty.close();
                }
            }
        ]
        , closeWith: ['click'] // acciones de cerrado
        , timeout: 5000 // Duración del noty 1000 -> 1 seg
        , animation: {
            open: 'animated flipInX', // Animate.css class names
            close: 'animated flipOutX', // Animate.css class names
            easing: 'swing', // unavailable - no need
            speed: 500 // unavailable - no need
        }
    });
}


/// <summary>
/// Nombre función: crearComboFecha
/// Detalle: Crear un objeto buscador con la funcionalidad de autocompletar
/// Desarrollador: Victor Alfonso Cardona Hernandez
/// Fecha: 2016 JUN 18
/// </summary>
/// <param name="sIdControl">Identificador del objeto que se transformara en autocompletar</param>
/// <param name="sFechaInicial">Ruta de la ventana o servicio en el cual estara la función que se ejecutara en ajax</param>
/// <param name="sFechaFin">determina la acción que se realizara en el servicio esta retornara los datos para la lista</param>
/// <param name="sValor">esta variable es para retornar un valor que estomado del resultado de la consulta , si trae o no datos </param>
function crearComboFecha(sIdControl, sFechaInicial, sFechaFin, sValor, fEvento, bHora) {
    $('#' + sIdControl).daterangepicker({
        singleDatePicker: true,
        showDropdowns: true,
        opens: "center",
        calender_style: "picker_4",
        format: bHora !== undefined && bHora === true ? "DD/MM/YYYY HH:mm" : "DD/MM/YYYY",
        minDate: sFechaInicial ? sFechaInicial : (bHora !== undefined && bHora === true ? "01/01/1950 00:00" : "01/01/1950"),
        maxDate: sFechaFin
        , inline: true
        , alwaysOpen: true
        , locale: {
            "applyLabel": "Ok",
            "cancelLabel": "Cancelar",
            "fromLabel": "De",
            "toLabel": "a",
            "customRangeLabel": "Custom",
            "daysOfWeek": [
                "Do",
                "Lu",
                "Ma",
                "Mi",
                "Ju",
                "Vi",
                "Sa"
            ],
            "monthNames": [
                "Enero",
                "Febrero",
                "Marzo",
                "Abril",
                "Mayo",
                "Junio",
                "Julio",
                "Agosto",
                "Septiembre",
                "Octubre",
                "Noviembre",
                "Diciembre"
            ],
            "firstDay": 1
        }


    }
        , fEvento

    );
    if (sValor) {
        $('#' + sIdControl).val(sValor);
    }
}



// Descripción: Funcion para validar los campos con un Json de Configuración 
function ValidarCamposJson(sIdentificador, objContenedor) {
    var sMensaje = "Para realizar esta operación debe: ";
    var JsonCampos = [];

    try {

        var lstCampos = [];

        if (objContenedor) {

            lstCampos = $(objContenedor).find("[validacion]");

        }
        else {

            lstCampos = sIdentificador ? $(sIdentificador).find("[validacion]") : $("[validacion]");

        }
        //obtener el listado de los campos requeridos de la ventana actual
        for (var i = 0; i < lstCampos.length; i++) {
            var objCampoRequerido = new Object();

            objCampo = lstCampos[i];
            var sMensajeCampo = $(objCampo).attr("mensaje") ? $(objCampo).attr("mensaje") : $("#" + objCampo.id).closest(".form-group").find(".block").text();
            var sControl = "";
            if ($(objCampo).hasClass("ui-autocomplete-input")) {
                sControl = "autocompletar";
            } else if ($(objCampo).hasClass("textareaEditor")) {
                sControl = "textareaEditor";
            } else if ($(objCampo).hasClass("dataTable")) {
                sControl = "dataTable";
            } else {
                sControl = objCampo.tagName.toLowerCase();
            }

            objCampoRequerido.Control = sControl;
            objCampoRequerido.Mensaje = sMensajeCampo;
            objCampoRequerido.EsObligatorio = $("#" + objCampo.id).attr("requerido") === "true";
            objCampoRequerido.Formato = ($("#" + objCampo.id).attr("validacion") ? $("#" + objCampo.id).attr("validacion") : "texto");

            if (objCampoRequerido.Control === "input" && objCampo.type === "radio") {
                objCampoRequerido.IdentificadorCampo = objCampo.name;
                objCampoRequerido.Control = "radio";
            } else {
                objCampoRequerido.IdentificadorCampo = objCampo.id;
            }
            JsonCampos.push(objCampoRequerido);
        }

        if (JsonCampos != null && JsonCampos.length > 0) {
            var iContador = 0;

            for (var i = 0; i < JsonCampos.length; i++) {

                var sValue = "";
                var bValidacion = true;
                var lstData = null;

                switch (JsonCampos[i]["Control"].toLowerCase()) {
                    case "span":

                        sValue = $.trim($("#" + JsonCampos[i]["IdentificadorCampo"]).text());

                        break;
                    case "autocompletar":

                        if (document.getElementById(JsonCampos[i]["IdentificadorCampo"]) !== null) {
                            sValue = document.getElementById(JsonCampos[i]["IdentificadorCampo"]).name;
                        }

                        break;
                    case "radio":
                        var lstRadios = $(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']");
                        for (var j = 0; j < lstRadios.length; j++) {
                            var objRadio = lstRadios[j];
                            if (objRadio.checked) {
                                sValue = objRadio.value;
                                break;
                            }
                        }
                        break;
                    case "radiobuttons":
                        if ($("#" + JsonCampos[i]["IdentificadorCampo"]).find(".opcionesRadio").length > 0) {
                            var lstDivOpcionesRadio = $("#" + JsonCampos[i]["IdentificadorCampo"]).find(".opcionesRadio")
                            for (var iDiv = 0; iDiv < lstDivOpcionesRadio.length; iDiv++) {

                                if ($(lstDivOpcionesRadio[iDiv]).closest(".row").find("input[type='text']").length > 1) {
                                    var objInput = $(lstDivOpcionesRadio[iDiv]).closest(".row").find("input[type='text']")[0];
                                    if (objInput !== null && objInput !== undefined && objInput.value !== "") {
                                        if ($(lstDivOpcionesRadio[iDiv]).find(":radio:checked").length === 0) {
                                            sValue = "";
                                            break;
                                        } else {
                                            sValue = "Ok";
                                        }
                                    }
                                }
                                else {
                                    if ($(lstDivOpcionesRadio[iDiv]).find(":radio:checked").length === 0) {
                                        sValue = "";
                                        break;
                                    } else {
                                        sValue = "Ok";
                                    }
                                }
                            }
                        } else {
                            sValue = $("#" + JsonCampos[i]["IdentificadorCampo"]).find(":radio:checked").val() !== undefined ? $("#" + JsonCampos[i]["IdentificadorCampo"]).find(":radio:checked").val() : "";
                        }
                        break;
                    case "input":
                    case "textarea":
                    case "textareaeditor":
                        sValue = $("#" + JsonCampos[i]["IdentificadorCampo"]).val();
                        break;
                    case "select":
                        var objSelect = $("#" + JsonCampos[i]["IdentificadorCampo"])[0];
                        if (objSelect !== null) {
                            if (objSelect.selectedIndex !== -1) {
                                sValue = objSelect.value;
                            } else {
                                sValue = "";
                            }
                        } else {
                            sValue = "";
                        }
                        break;
                    case "datatable":
                        var objDataTable = $("#" + JsonCampos[i]["IdentificadorCampo"]).DataTable();
                        var lstData = objDataTable.data();
                        sValue = lstData.length;
                        break;
                }

                if (JsonCampos[i]["EsObligatorio"] || sValue != "") {
                    if (JsonCampos[i]["Formato"].toLowerCase() === "table") {
                        bValidacion = (sValue !== 0);
                    } else {
                        var sPatron = glstCodidosValidacion[JsonCampos[i]["Formato"]];
                        bValidacion = validarExpresiones(sPatron, sValue);
                    }
                }
                var bCumpleCondicionValidar = true;
                if (JsonCampos[i].CondicionValidar) {
                    bCumpleCondicionValidar = eval(JsonCampos[i].CondicionValidar);
                }

                if (!bValidacion && bCumpleCondicionValidar) {
                    iContador = iContador + 1;
                    sMensaje += "\n " + (iContador).toString() + ". ";
                    if (sValue != "") {

                        $("#" + JsonCampos[i]["IdentificadorCampo"]).addClass("FormatoIncorrecto");

                        var sTextoFormato = "";
                        switch (JsonCampos[i]["Formato"]) {
                            case "FECHA":
                                sTextoFormato = "fecha (\"DD/MM/YYYY\")";
                                break;
                            case "TEXTO":
                                sTextoFormato = "texto";
                                break;
                            case "ENTERO":
                                sTextoFormato = "número entero";
                                break;
                            case "REAL":
                                sTextoFormato = "número decimal";
                                break;
                            case "HoraMilitar":
                                sTextoFormato = "hora (\"HH:MM\")";
                                break;
                            case "EMAIL":
                                sTextoFormato = "correo electrónico";
                                break;
                            case "correo":
                                sTextoFormato = "correo electrónico";
                                break;

                        }

                        sMensaje += "Digitar un formato [" + sTextoFormato + "] correcto para el campo " + JsonCampos[i]["Mensaje"] + ".";

                    }
                    else {

                        if (JsonCampos[i]["Control"].toLowerCase() == "radio") {
                            if ($(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").closest(".btn-group").length > 0) {
                                $(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").closest(".btn-group").addClass("cssCampoObligatorio")
                            } else {
                                $(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").addClass("cssCampoObligatorio");
                            }
                            sMensaje += "Seleccionar una opción para el campo " + JsonCampos[i]["Mensaje"] + ".";
                        }
                        else if (JsonCampos[i]["Control"].toLowerCase() == "select") {

                            if ($("#select2-" + JsonCampos[i]["IdentificadorCampo"] + "-container").length > 0) {
                                $("#select2-" + JsonCampos[i]["IdentificadorCampo"] + "-container").addClass("cssCampoObligatorio")
                            } else {
                                $("#" + JsonCampos[i]["IdentificadorCampo"]).addClass("cssCampoObligatorio");
                            }
                            sMensaje += "Seleccionar una opción para el campo " + JsonCampos[i]["Mensaje"] + ".";
                        }
                        else if (JsonCampos[i]["Control"].toLowerCase() == "autocompletar") {
                            $("#" + JsonCampos[i]["IdentificadorCampo"]).addClass("cssCampoObligatorio");
                            sMensaje += "Seleccionar una opción para el campo  " + JsonCampos[i]["Mensaje"] + ".";
                        }
                        else if (JsonCampos[i]["Control"].toLowerCase() == "textareaeditor") {
                            $(".jHtmlArea").addClass("cssCampoObligatorio");
                            sMensaje += "Digitar el campo " + JsonCampos[i]["Mensaje"] + ".";
                        }
                        else if (JsonCampos[i]["Control"].toLowerCase() == "datatable") {
                            $("#" + JsonCampos[i]["IdentificadorCampo"]).addClass("cssCampoObligatorio");
                            sMensaje += "Agregar por lo menos un registro a la tabla de " + JsonCampos[i]["Mensaje"] + ".";
                        }
                        else {
                            $("#" + JsonCampos[i]["IdentificadorCampo"]).addClass("cssCampoObligatorio");
                            sMensaje += "Digitar el campo " + JsonCampos[i]["Mensaje"] + ".";
                        }
                    }
                }
                else {

                    $("#" + JsonCampos[i]["IdentificadorCampo"]).removeClass("FormatoIncorrecto");
                    $("#" + JsonCampos[i]["IdentificadorCampo"]).removeClass("cssCampoObligatorio");
                    $(".jHtmlArea").removeClass("cssCampoObligatorio");
                    $("#select2-" + JsonCampos[i]["IdentificadorCampo"] + "-container").removeClass("cssCampoObligatorio")
                    $(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").removeClass("cssCampoObligatorio");
                    $("#" + JsonCampos[i]["IdentificadorCampo"]).find(".btn-group").removeClass("cssCampoObligatorio");
                    if ($(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").closest(".btn-group").length > 0) {
                        $(":radio[name='" + JsonCampos[i]["IdentificadorCampo"] + "']").closest(".btn-group").removeClass("cssCampoObligatorio")
                    }

                }
            }

            var objCampoFoco = null;

            if (iContador > 0) {
                mostrarAlertas(sMensaje);

                if ((sIdentificador ? $(sIdentificador).find(".CampoRequerido") : $(".CampoRequerido")).length > 0) {
                    objCampoFoco = (sIdentificador ? $(sIdentificador).find(".CampoRequerido") : $(".CampoRequerido"))[0];
                } else if ((sIdentificador ? $(sIdentificador).find(".FormatoIncorrecto") : $(".FormatoIncorrecto")).length > 0) {
                    objCampoFoco = (sIdentificador ? $(sIdentificador).find(".FormatoIncorrecto") : $(".FormatoIncorrecto"))[0];
                }
                if (objCampoFoco !== null) {
                    ponerFocoCampo(objCampoFoco);
                }
                return false;
            }
            else {
                if ((sIdentificador ? $(sIdentificador).find(".CampoRequerido") : $(".CampoRequerido")).length > 0) {
                    objCampoFoco = (sIdentificador ? $(sIdentificador).find(".CampoRequerido") : $(".CampoRequerido"))[0];
                } else if ((sIdentificador ? $(sIdentificador).find(".FormatoIncorrecto") : $(".FormatoIncorrecto")).length > 0) {
                    objCampoFoco = (sIdentificador ? $(sIdentificador).find(".FormatoIncorrecto") : $(".FormatoIncorrecto"))[0];
                } else {
                    return true;
                }

                if (objCampoFoco !== null) {
                    mostrarAlertas("Existen campos requeridos pendientes por diligenciar, por favor verifique.");
                    ponerFocoCampo(objCampoFoco);
                    return false;
                }
                return true;
            }
        } else {
            mostrarAlertas("No se encontraron campos para validar.", "error");
            return false;
        }
    } catch (ex) {
        var objError = new Error();
        objError.message = "Error en ValidarCampoJson:\n" + ex.message;
        throw (objError);
    }
}

// Desarrollador: Victor alfonso cardona hernandez
// Fecha: 16/02/2016
// Descripción: Funcion poner foco al campo que esta marcado como requerido
// Parametro: objCampoFoco --> objeto del campo que se le pondra el foco
function ponerFocoCampo(objCampoFoco) {
    try {
        if (objCampoFoco !== null) {
            if (!$(objCampoFoco).is(':visible')) {
                var objPanel = $(objCampoFoco).closest(".panel-default").find(".panelCollapsed")[0];
                if (objPanel !== undefined && objPanel !== null) {
                    if ($(objPanel).hasClass('panel-collapsed')) {
                        $(objPanel).trigger("click");
                    }
                }

                var objSubPanel = $(objCampoFoco).closest(".panel-default").find(".subPanelCollapsed")[0];
                if (objSubPanel !== undefined && objSubPanel !== null) {
                    if ($(objSubPanel).hasClass('panel-collapsed')) {
                        $(objSubPanel).trigger("click");
                    }

                    objPanel = $($(objSubPanel).closest(".panel-body")[0]).closest(".panel-default").find(".panelCollapsed");
                    if (objPanel !== undefined && objPanel !== null) {
                        if ($(objPanel).hasClass('panel-collapsed')) {
                            $(objPanel).trigger("click");
                        }
                    }
                }
            }
            var iPosicion = $(objCampoFoco).offset().top;
            if (iPosicion - 150 > 0) {
                iPosicion = (iPosicion - 150);
            }

            var sObjetoScroll = "html, body";

            try {
                var objIframeMaqueta = parent.obtenerIframePestanaActiva();
                var objDivTab = null;
                if (objIframeMaqueta && objIframeMaqueta !== null) {
                    objDivTab = $(objIframeMaqueta).closest("div")[0];
                }
                sObjetoScroll = objDivTab;
            } catch (e) { }
            //hacemos que el scroll se ubique
            $(sObjetoScroll).animate({ scrollTop: iPosicion + "px" }, 700, "swing", function () {
                objCampoFoco.focus();
            });
        }
    } catch (e) {
        var objError = new Error();
        objError.message = "Error en ponerFocoCampo():\n" + e.message;
        throw (objError);
    }
}

// Parametros: sFecha --> cadena  de fecha que se le dara formato de yyyy-MM-dd HH:mm Formaro de entrada dd/MM/yyyy
// Parametros: sHora --> cadena  de la hora 
// Descripción: Función para que los controles de kendo se despliegen al dar click
function darFormato112Fecha(sFormatiIn, sFecha, sHora) {
    var sResultado = "";
    var lstValores = null;
    if (sFecha && sFecha !== "") {
        switch (sFormatiIn) {
            case "120":
                lstValores = sFecha.split('-');
                if (lstValores.length > 0) {
                    sResultado = lstValores[0] + lstValores[1] + lstValores[2];
                    if (sHora && sHora !== "") {
                        sResultado = sResultado + " " + sHora;
                    }
                }
                break;
            case "103":
                lstValores = sFecha.split('/');
                if (lstValores.length > 0) {
                    sResultado = lstValores[2] + lstValores[1] + lstValores[0];
                    if (sHora && sHora !== "") {
                        sResultado = sResultado + " " + sHora;
                    }
                }
                break;
        }
    }
    return sResultado;
}


// Parametros: sFormatiIn --> formato con el que ingresa la cadena de fecha
// Parametros: sFecha --> cadena  de fecha que se le dara formato
// Parametros: sHora --> cadena  de la hora 
// Descripción: dar formato 103 SQL a una cadena de fecha 
function darFormato103Fecha(sFormatiIn, sFecha, sHora) {
    var sResultado = "";
    var lstValores = [];
    if (sFecha && sFecha !== "") {
        switch (sFormatiIn) {
            case "120":
                lstValores = sFecha.split('-');
                if (lstValores.length > 0) {
                    sResultado = lstValores[2] + "/" + lstValores[1] + "/" + lstValores[0];
                    if (sHora && sHora !== "") {
                        sResultado = sResultado + " " + sHora;
                    }
                }
                break;
            case "112":
                lstValores.push(sFecha.substring(0, 4)); //20150606
                lstValores.push(sFecha.substring(4, 6));
                lstValores.push(sFecha.substring(6, 8));
                if (lstValores.length > 0) {
                    sResultado = lstValores[2] + "/" + lstValores[1] + "/" + lstValores[0];
                    if (sHora && sHora !== "") {
                        sResultado = sResultado + " " + sHora;
                    }
                }
                break;
        }
    }
    return sResultado;
}
// Parametros: sFecha --> cadena de la fecha  
// Parametros: sHora --> cadena de la hora 
// Parametros: sFormatoSql --> Cadena que indica el formato con el que vien la fecha seg formato Sql
// Descripción: deshabilitar los items de un control de menu de kendo
function obtenerObjetoDate(sFecha, sHora, sFormatoSql) {
    var lstValoresFecha = null;
    var lstValoresHora = null;
    var fFecha = null;
    switch (sFormatoSql) {
        case "120":
        case "121":
            lstValoresFecha = sFecha.split("-");
            if (sHora && sHora !== "") {
                lstValoresHora = sHora.split(":");
            }

            if (lstValoresHora === null) {
                fFecha = new Date(parseFloat(lstValoresFecha[0]), (parseFloat(lstValoresFecha[1]) - 1), parseFloat(lstValoresFecha[2]));
            } else {
                fFecha = new Date(parseFloat(lstValoresFecha[0]), (parseFloat(lstValoresFecha[1]) - 1), parseFloat(lstValoresFecha[2]), parseFloat(lstValoresHora[0]), parseFloat(lstValoresHora[1]), (lstValoresHora[2] ? parseFloat(lstValoresHora[2]) : 0));
            }

            break;
        case "103":
            lstValoresFecha = sFecha.split("/");
            if (sHora && sHora !== "") {
                lstValoresHora = sHora.split(":");
            }

            if (lstValoresHora === null) {
                fFecha = new Date(parseFloat(lstValoresFecha[2]), (parseFloat(lstValoresFecha[1]) - 1), parseFloat(lstValoresFecha[0]));
            } else {
                fFecha = new Date(parseFloat(lstValoresFecha[2]), (parseFloat(lstValoresFecha[1]) - 1), parseFloat(lstValoresFecha[0]), parseFloat(lstValoresHora[0]), parseFloat(lstValoresHora[1]), (lstValoresHora[2] ? parseFloat(lstValoresHora[2]) : 0));
            }
            break;

        case "112":
            var sFecha = sFecha + sHora ? " " + sHora : "";
            fFecha = new Date(sFecha);
            break;
    }

    return fFecha;
}

// Nombre:  Victor Alfonso Cardona Hernandez
// Función: Función para validar las fechas al cambiar.
function validarFecha(objCampo) {
    var sCadena = "";
    var codidosValidacion = new Array();
    codidosValidacion["FECHA"] = "^(?:(?:0?[1-9]|1\\d|2[0-8])(\\/|-)(?:0?[1-9]|1[0-2]))(\\/|-)(?:[1-9]\\d\\d\\d|\\d[1-9]\\d\\d|\\d\\d[1-9]\\d|\\d\\d\\d[1-9])$|^(?:(?:31(\\/|-)(?:0?[13578]|1[02]))|(?:(?:29|30)(\\/|-)(?:0?[1,3-9]|1[0-2])))(\\/|-)(?:[1-9]\\d\\d\\d|\d[1-9]\\d\\d|\\d\\d[1-9]\\d|\\d\\d\\d[1-9])$|^(29(\\/|-)0?2)(\\/|-)(?:(?:0[48]00|[13579][26]00|[2468][048]00)|(?:\\d\\d)?(?:0[48]|[2468][048]|[13579][26]))$";
    if (objCampo != null) {
        sCadena = objCampo.value;
        if (sCadena != "") {
            if (testear(codidosValidacion["FECHA"], sCadena)) {
                $(objCampo).attr("title", "");
                $(objCampo).removeClass("FechaFormatoIncorrecto");
                return true;
            } else {
                $(objCampo).attr("title", "Formato de fecha incorrecto (dd/mm/aaaa) o fecha incorrecta, por favor verifique.");
                $(objCampo).addClass("FechaFormatoIncorrecto");
                return false;
            }
        }
    }
}

// Descripción: Funcion para validar valor con expresion regular
// Parametro: sExpresionRegular --> Expresion regular
// Parametro: sValue --> Valor a comparar
function testear(sExpresionRegular, sValue) {
    try {
        var ObjPatron = new RegExp(sExpresionRegular, "gi");
        return ObjPatron.test(sValue);
    } catch (e) {
        MostrarMensaje("error", "ERROR: testear() [ " + e.name + " - " + e.message + " ]");
    }
}

function sObtenerCadenaFecha(objFecha, sFormato, bMostrarHora) {
    if (!objFecha) {
        objFecha = new Date();
    }
    var sFecha = "";
    var sDia = "";
    var sMes = "";
    var sAnio = "";
    var sHora = "";
    var sMinuto = "";
    var sSegundos = "";

    sDia = objFecha.getDate().toString();  	            //Returns the day of the month (from 1-31)
    sMes = (objFecha.getMonth() + 1).toString();        //Returns the month (from 0-11)
    sAnio = objFecha.getFullYear().toString();         //Returns the year
    sHora = objFecha.getHours().toString();             //Returns the hour (from 0-23)
    sMinuto = objFecha.getMinutes().toString();         //Returns the minutes (from 0-59)
    sSegundos = objFecha.getSeconds().toString();       //Returns the Seconds (from 0-59)

    switch (sFormato) {
        case "120":
        case "121":
            sFecha += sAnio + "-";
            sFecha += (sMes.length == 1 ? "0" + sMes : sMes) + "-";
            sFecha += (sDia.length == 1 ? "0" + sDia : sDia);

            break;
        case "103":
            sFecha += (sDia.length == 1 ? "0" + sDia : sDia) + "/";
            sFecha += (sMes.length == 1 ? "0" + sMes : sMes) + "/";
            sFecha += sAnio;
            break;
        case "112":
            sFecha += sAnio;
            sFecha += (sMes.length == 1 ? "0" + sMes : sMes);
            sFecha += (sDia.length == 1 ? "0" + sDia : sDia);
            break;
    }

    if (bMostrarHora) {
        sFecha += " " + (sHora.length == 1 ? "0" + sHora : sHora) + ":";
        sFecha += (sMinuto.length == 1 ? "0" + sMinuto : sMinuto);
    }

    return sFecha;
}


function calcularDigitoVerificacion(myNit) {
    var vpri,
        x,
        y,
        z;

    // Se limpia el Nit
    myNit = myNit.replace(/\s/g, ""); // Espacios
    myNit = myNit.replace(/,/g, ""); // Comas
    myNit = myNit.replace(/\./g, ""); // Puntos
    myNit = myNit.replace(/-/g, ""); // Guiones

    // Se valida el nit
    if (isNaN(myNit)) {
        console.log("El nit/cédula '" + myNit + "' no es válido(a).");
        return "";
    };

    // Procedimiento
    vpri = new Array(16);
    z = myNit.length;

    vpri[1] = 3;
    vpri[2] = 7;
    vpri[3] = 13;
    vpri[4] = 17;
    vpri[5] = 19;
    vpri[6] = 23;
    vpri[7] = 29;
    vpri[8] = 37;
    vpri[9] = 41;
    vpri[10] = 43;
    vpri[11] = 47;
    vpri[12] = 53;
    vpri[13] = 59;
    vpri[14] = 67;
    vpri[15] = 71;

    x = 0;
    y = 0;
    for (var i = 0; i < z; i++) {
        y = (myNit.substr(i, 1));
        // console.log ( y + "x" + vpri[z-i] + ":" ) ;

        x += (y * vpri[z - i]);
        // console.log ( x ) ;    
    }

    y = x % 11;
    // console.log ( y ) ;

    return (y > 1) ? 11 - y : y;
}

function obtenerQueryString(sKey, sUrlPagina) {

    var sUrl = sUrlPagina ? sUrlPagina : location.href;
    var sDatosQuery = sUrl.split("?")[1];
    var lstDatosQuery = null;
    var lstQueryString = [];

    if (sDatosQuery) {

        lstDatosQuery = sDatosQuery.split("&");

        for (var i = 0; i < lstDatosQuery.length; i++) {

            var lstData = lstDatosQuery[i].split("=");
            var sKeyData = lstData[0];
            var sData = lstData[1];

            lstQueryString[sKeyData] = sData;

        }

    }

    return lstQueryString[sKey];

}

function ObtenerFechaActual(bHora) {
    var sFechaResult = "";
    var ObjFechaActual = new Date();
    var iDias = ObjFechaActual.getDate();
    var iMeses = ObjFechaActual.getMonth() + 1;
    var iAños = ObjFechaActual.getFullYear();
    var iHoras = ObjFechaActual.getHours();
    var iMinutos = ObjFechaActual.getMinutes();

    iDias = iDias < 10 ? "0" + iDias : iDias;
    iMeses = iMeses < 10 ? "0" + iMeses : iMeses;
    iHoras = iHoras < 10 ? "0" + iHoras : iHoras;
    iMinutos = iMinutos < 10 ? "0" + iMinutos : iMinutos;

    sFechaResult = bHora ? iDias + '/' + iMeses + '/' + iAños + " " + iHoras + ":" + iMinutos : iDias + '/' + iMeses + '/' + iAños;
    return sFechaResult;
}



/// <summary>
/// Nombre función: crearBuscadorAutoCompletar
/// Detalle: Crear un objeto buscador con la funcionalidad de autocompletar
/// Desarrollador: Victor Alfonso Cardona Hernandez
/// Fecha: 2016 JUN 18
/// </summary>
/// <param name="sIdControl">Identificador del objeto que se transformara en autocompletar</param>
/// <param name="sUrl">Ruta de la ventana o servicio en el cual estara la función que se ejecutara en ajax</param>
/// <param name="sAccion">determina la acción que se realizara en el servicio esta retornara los datos para la lista</param>
/// <param name="funAjax">esta función es para el armar el esquema de datos de la petición ajax</param>
/// <param name="funRespuesta">esta es la función que se ejecutara al momento de seleccionar un item de la lista</param>
/// <param name="sVarValidarExistencia">esta variable es para retornar un valor que estomado del resultado de la consulta , si trae o no datos </param>
function crearBuscadorAutoCompletar(sIdControl, sUrl, sAccion, funAjax, funRespuesta, lstColumnas, sIdLabelExiste, sCampoText, sCampoValue) {
    // Sets up the multicolumn autocomplete widget.
    $("#" + sIdControl).mcautocomplete({
        showHeader: true // Está propiedad indica si el automenpletar va mostrar una cabecera
        //Se agregan las columnas que tendra el autoCompletar
        , columns: (lstColumnas ? lstColumnas : [
            { "Visible": true, "Width": 100, "Caption": "Nombre", "FieldName": "Nombre" }
            , { "Visible": false, "Width": 0, "Caption": "Id", "FieldName": "Id" }
        ])
        //Se agregan las Funciones que se realizaran al seleccionar el medicamneto
        , select: function (event, ui) {
            this.value = (ui.item ? ui.item[sCampoText] : '');
            this.name = ui.item[sCampoValue];
            //selecobtenerDatoscionarAutoCompletarRegistros(ui.item, this.id);
            if (funRespuesta) {
                funRespuesta(ui.item, this.id);
            }
            $(this).removeClass("CampoRequerido");
            return false;
        },
        minLength: 3, // -> Esta propiedad indica cual es el minimo de caracteres que debe tener el componente para realizar el llamado al servicio.
        open: function () {
            $(this).removeClass("ui-corner-all").addClass("ui-corner-top");
        },
        close: function () {
            $(this).removeClass("ui-corner-top").addClass("ui-corner-all");
        },
        source: function (request, response) {

            $.ajax({
                type: "POST",
                url: sUrl, // "frmConsultaExterna.aspx/sEventosServidor",
                data: funAjax(sAccion, request.term),
                headers: gsAutenticacion,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (data) {
                    var lstResult;
                    var objJsonRespuesta = null;
                    var bValidarExistencia = false;
                    //Agregar el set de datos obtenidos del web services
                    if (data != undefined) {
                        objJsonRespuesta = data;
                        if (objJsonRespuesta != null) {
                            if (objJsonRespuesta.Error) {
                                mostrarAlertas("Error en ajax de buscador autocompletar():\n" + objJsonRespuesta.Mensaje, "error");
                            } else {
                                bValidarExistencia = (objJsonRespuesta.LstResult.length > 0);
                                lstResult = objJsonRespuesta.LstResult;
                            }
                        }
                    }

                    if (sIdLabelExiste) {

                        if (!bValidarExistencia) {
                            $("#" + sIdLabelExiste).text("No se encontraron resultados.");
                            $("#" + sIdLabelExiste).css("color", "red");
                        } else {
                            $("#" + sIdLabelExiste).text("Ingresar mínimo 3 caracteres para filtrar.");
                            $("#" + sIdLabelExiste).css("color", "darkgray");
                        }

                        //if (bValidarExistencia) {
                        //    eval(sVarValidarExistencia + " = true");
                        //} else {
                        //    eval(sVarValidarExistencia + " = false");
                        //}
                    }

                    $("#" + sIdControl)[0].name = "";
                    if (lstResult != undefined && lstResult.length === 1) {
                        if ($("#" + sIdControl)[0].value === lstResult[0].Nombre) {
                            $("#" + sIdControl)[0].value = lstResult[0].Nombre;
                            $("#" + sIdControl)[0].name = lstResult[0].Id;
                            $("#" + sIdControl).removeClass("CampoRequerido");
                            if (funRespuesta) {
                                funRespuesta(lstResult[0], this.id);
                            }
                        } else {
                            response(lstResult);
                        }
                    } else {
                        response(lstResult);
                    }
                },
                error: onError
            });
        }
    });

    $("#" + sIdControl).on("keyup", limpiarCamposBuscadorAutocompletar);

}

function limpiarCamposBuscadorAutocompletar() {
    onKeyUpBuscador(this, event);
}

//limpiar los name de los controles de autocompletar
function onKeyUpBuscador(objBuscador, objEvento) {
    if (objEvento.keyCode !== 13) {
        objBuscador.name = "";
    }
}

// Nombre: onError
// Fecha:  2016 ENE 25
// Desarrollador: Victor Alfonso Cardona Hernandez
// Función:  Respuesta de error del webMethods
function onError(objError) {
    if (objError._statusCode !== 0) {
        mostrarAlertas("Error en ajax:" + objError._message, "error");
    }
}

function limpiarCamposBuscadorAutocompletar() {

    var objBuscador = this;
    var objEvento = event;

    if (objEvento.keyCode !== 13) {
        objBuscador.name = "";
    }
}


function obtenerDatosTableGeneral(lstColumnas, lstData, sCriterio) {
    var sXml = "";

    if (lstData.length > 0) {
        sXml = "<Data>";
        for (var i = 0; i < lstData.length; i++) {

            var bAgregar = true;

            if (sCriterio) {
                bAgregar = eval(sCriterio);
            }

            if (bAgregar) {

                sXml += "<row>";

                for (var j = 0; j < lstColumnas.length; j++) {

                    sXml += "<" + lstColumnas[j] + ">" + lstData[i][lstColumnas[j]] + "</" + lstColumnas[j] + ">";

                }

                sXml += "</row>";

            }

        }
        sXml += "</Data>";
    }
    return sXml;
}


function consultarConsecutivoGeneral(sIdEmpresa, sCodigo, funRespuesta, sOperacion) {
    $.ajax({
        type: "GET",
        url: gsUrlApi + "/Consecutivos/Listar?IdEmpresa=" + sIdEmpresa + "&Codigo=" + sCodigo + "&Operacion=" + (sOperacion !== undefined ? sOperacion : ""),
        headers: gsAutenticacion,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            if (result.Error) {
                mostrarAlertas(result.Mensaje, "error");
                return;
            }

            var sConsucutivo = result.ListaConsecutivos[0].Consecutivo !== null ? result.ListaConsecutivos[0].Consecutivo : "";

            if (funRespuesta) {
                funRespuesta(sConsucutivo);
            }

        },
        error: function (e) {
            mostrarAlertas("Error en ajax al cargar tipo de consulta.", "error");
        }
    });
}

function FormatearValorMoney(sValor) {
    var sRetorno;
    try {

        sRetorno = parseFloat(sValor, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString();

    } catch (ex) {
        alert(ex.message);
    }

    return sRetorno;
}

function keyUpSoloNumero(event) {
    var objEvento = event.srcElement;
    var iValorResultante = -1;
    iKey = event.keyCode || event.which;
    sTecla = String.fromCharCode(iKey).toLowerCase();
    sCaracteresPermitidos = "0123456789";

    if (sCaracteresPermitidos.indexOf(sTecla) == -1) {
        return false;
    }

}

function formatPrecio(input) {
    var num = input.value.replace(/\./g, '');
    if (!isNaN(num)) {
        num = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g, '$1.');
        num = num.split('').reverse().join('').replace(/^[\.]/, '');
        input.value = num;
    }
}

function keyUpSoloNumeroValidarRango(e, sValoresRango) {
    var lstValores = null;
    var objEvento = e.srcElement;
    var iValorResultante = -1;
    iKey = e.keyCode || e.which;
    sTecla = String.fromCharCode(iKey).toLowerCase();
    sCaracteresPermitidos = "0123456789";
    vEspeciales = [8];

    bTecla_Especial = false
    for (var i in vEspeciales) {
        if (iKey == vEspeciales[i]) {
            bTecla_Especial = true;
            break;
        }
    }

    if (sCaracteresPermitidos.indexOf(sTecla) == -1 && !bTecla_Especial) {
        return false;
    }

    if (sValoresRango) {
        if (sValoresRango.indexOf('-') != -1) {
            lstValores = sValoresRango.split("-");
            iValorResultante = parseInt(objEvento.value + sTecla);
            if (!(iValorResultante >= parseInt(lstValores[0]) && parseInt(lstValores[1]) >= iValorResultante)) {
                return false;
            }
        }
    }

}

// Nombre: abrirExploradorArchivos
// Parametro: objEvento --> objeto del control que dispara el evento
// Función: abriri el explorador de archivos del dispositivo
function mostrarBuscadorImagen(objEvento) {
    gObjEventoImagen = objEvento;
    document.getElementById("input_FileImagen").click();
}

/// <summary>
/// Nombre función: handleFileSelect
/// Detalle: obtener la img en base64
/// Desarrollador: Victor Alfonso Cardona Hernandez
/// Fecha: 2016 JUN 18
/// </summary> 
var handleFileSelect = function (evt) {
    var objImagen = $("#input_FileImagen")[0].files;
    var fileData = objImagen[0];

    if (fileData) {

        if (fileData.size > 1050000) {

            mostrarAlertas("La imagen a subir debe tener un tamaño maximo de 1 MB, por favor verifique.");
            return;
        }

        if (!FileReader.prototype.readAsBinaryString) {
            FileReader.prototype.readAsBinaryString = function (fileData) {
                var binary = "";
                var pt = this;
                var reader = new FileReader();
                reader.onload = function (e) {
                    var bytes = new Uint8Array(reader.result);
                    var length = bytes.byteLength;
                    for (var i = 0; i < length; i++) {
                        binary += String.fromCharCode(bytes[i]);
                    }
                    //pt.result  - readonly so assign binary
                    pt.content = binary;
                    $(pt).trigger('onload');
                }
                reader.readAsArrayBuffer(fileData);
            }
        }
        var reader = new FileReader();
        reader.readAsBinaryString(fileData);
        reader.onload = function (e) {
            if (reader.result) reader.content = reader.result;
            var base64Data = btoa(reader.content);

            $(gObjEventoImagen).prop("src", "data:image/jpeg;base64," + base64Data);
            $("#input_FileImagen").val('');

        }

    }

};

function inicializarInputFile(fnInputFile) {
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        document.getElementById('input_FileImagen').addEventListener('change', fnInputFile ? fnInputFile : handleFileSelect, false);
    } else {
        mostrarAlertas('No es posible subir imagenes usando este navegador web.', "error");
    }
}

//-----------------------------------------
function redondearValores(rValor, iDecimas) {
    iDecimas = (!iDecimas ? 2 : iDecimas);
    return Math.round(parseFloat(rValor) * Math.pow(10, iDecimas)) / Math.pow(10, iDecimas);
}

function redondiarEnteroSup(rValor) {
    return Math.ceil(rValor);
}

function formatPrecio(input) {
    var num = input.value.replace(/\./g, '');
    if (!isNaN(num)) {
        num = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g, '$1.');
        num = num.split('').reverse().join('').replace(/^[\.]/, '');
        input.value = num;
    }
}


function FormatearValorMoney(sValor) {
    var sRetorno;
    try {

        sRetorno = parseFloat(sValor, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString();

    } catch (ex) {
        alert(ex.message);
    }

    return sRetorno;
}

function formatPrecioText(sValor) {
    var sResult = "";
    var lstValores = "";
    sResult = sValor.replace(/\./g, ',');

    lstValores = sResult.split(",");

    sResult = lstValores[0].replace(/\./g, '');

    if (!isNaN(sResult)) {

        sResult = sResult.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g, '$1.');
        sResult = sResult.split('').reverse().join('').replace(/^[\.]/, '');

    }

    if (lstValores[1]) {
        sResult += "," + lstValores[1];
    }

    return sResult;
}

function consultarFechaActual(funRespuesta) {
    $.ajax({
        type: "GET",
        url: gsUrlApi + "/Utilidades/obtenerFechaActual",
        headers: gsAutenticacion,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            if (result.Error) {
                mostrarAlertas(result.Mensaje, "error");
                return;
            }

            var sDato = result.Mensaje;

            if (funRespuesta) {
                funRespuesta(sDato);
            }

        },
        error: function (e) {
            mostrarAlertas("Error en ajax consultarFechaActual().", "error");
        }
    });
}

/// <summary>
///  imprimirRegistros()
///  funcion: imprimir el documento
/// </summary>
function imprimirRegistros(sIdDivImpresion, bBorrarDatosOcultos, sHtml, bRetornarHtml) {
    var sEstiloTablas = '';
    var div_impresion = '';
    var sIdTemporalDivImpresion = 'div_RegistrosTemp';

    try {

        div_impresion = '<div id="' + sIdTemporalDivImpresion + '"></div>'; //codigo html del div
        $(div_impresion).appendTo('body'); //se agrega al elemento body, para hacerlo funcional.
        if (sHtml) {
            $("#" + sIdTemporalDivImpresion).html(sHtml); //se asigna la pagina que viene desde el servidor.
        } else {
            $("#" + sIdTemporalDivImpresion).html($(sIdDivImpresion ? "#" + sIdDivImpresion : "#div_Registros").html()); //se asigna la pagina que viene desde el servidor.
        }
        if (bBorrarDatosOcultos) {
            $("#" + sIdTemporalDivImpresion).find(".cssCampoOculto").remove();
        }
        $("#" + sIdTemporalDivImpresion).find(".divBtn").remove(); //se invoca la impresion.
        $("#" + sIdTemporalDivImpresion).find(".cssBodyXslt").find("table").css("font-size", "8pt"); //se invoca la impresion.
        $("#" + sIdTemporalDivImpresion).find(".fixed_height_320").css("height", "auto"); //se invoca la impresion.

        if (bRetornarHtml) {
            sHtml = $("#" + sIdTemporalDivImpresion).html()
            $("#" + sIdTemporalDivImpresion).remove(); //se remueve el div temporal despues de la impresion.     
            return sHtml;
        } else {
            $("#" + sIdTemporalDivImpresion).jqprint(); //se invoca la impresion.
            $("#" + sIdTemporalDivImpresion).remove(); //se remueve el div temporal despues de la impresion.     
        }


    } catch (e) {
        mostrarAlertas('Error en imprimirRegistros():\n' + e.message, "error");
    }
}

function moverScroll(iTop) {
    //hacemos que el scroll se ubique
    parent.$("html, body").animate({ scrollTop: iTop + "px" }, 700, "swing");
}

function impresionGeneralHtml(sData) {

    $.ajax({
        type: "POST",
        url: gsUrlApi + "/Impresiones/obtenerPmpresion",
        data: sData,
        headers: gsAutenticacion,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {

            if (result.Error) {

                mostrarAlertas(result.Mensaje, "error");
                return;

            }

            if (parent.mostrarpopUpImpresion) {

                parent.mostrarpopUpImpresion(result.Result);

            } else {

                mostrarAlertas("No se encontro para visualizar la impresión.", "error");

            }

        },
        error: function (e) {
            mostrarAlertas("Error en ajax al imprimir registro.", "error");
        }
    });

}



function mostratnGeneraPupup(sData) {

    $.ajax({
        type: "POST",
        url: gsUrlApi + "/Impresiones/obtenerPmpresion",
        data: sData,
        headers: gsAutenticacion,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {

            if (result.Error) {

                mostrarAlertas(result.Mensaje, "error");
                return;

            }

            if (parent.mostrarpopUp) {

                parent.mostrarpopUp(result.Result);

            } else {

                mostrarAlertas("No se encontro para visualizar la transaccion.", "error");

            }

        },
        error: function (e) {
            mostrarAlertas("Error en ajax al imprimir registro.", "error");
        }
    });

}