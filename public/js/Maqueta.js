var gObjSesion = null;
var gObjEmpresa = null;
var gbAjustar = false;
var gObjPopUp = null;


$(document).ready(function () {

    var objSesion = JSON.parse(localStorage.getItem('Sesion'));
    if (objSesion == null || objSesion == undefined) {

        window.location.replace("Login.html");
        return;

    }
    else {

        gObjSesion = objSesion;
        consultarEmpresa();
        cargarMenus(objSesion);

        actualizarDataUsuarioPerfil(gObjSesion.user);
     
       // redireccionarVentana(this, "Operativos/Dashboard/Dashboard.html", "Dashboard", "0");
    }

    $('html').removeClass('canvas');
    setInterval(ajustarAltoContenidoAreaTrabajo, 900);
    $("#iframe_BoxJob").on("load", onloadIframeAreaTrabajo);

});

function cerrarSesion() {

    localStorage.clear();
    location.href = "login.html";

}

function abrirPrefil() {

    redireccionarVentana(this, 'Maestros/Sistema/Usuarios/Usuarios.html?Dato=' + gObjSesion.user.IdUsuario, 'Perfil', '|G|', '7');

}

function actualizarDataUsuarioPerfil(user) {

    if (user && user !== null) {

        gObjSesion.user = user;

        //document.getElementById("img_Avatar1").src = gsUrlApi + "/Imagenes/obtenerImagen?sImagen=" + gObjSesion.user.Foto + "&sMaestro=usuarios&id_empresa=" + gObjSesion.user.id_empresa;
        //document.getElementById("img_Avatar2").src = gsUrlApi + "/Imagenes/obtenerImagen?sImagen=" + gObjSesion.user.Foto + "&sMaestro=usuarios&id_empresa=" + gObjSesion.user.id_empresa;

    }

}

function consultarEmpresa() {


    var sid_empresa = gObjSesion.user.id_empresa;

    var sIdEmpresa = gObjSesion.id_empresa;


    
    var formData = new FormData();
    formData.append("id",sid_empresa);
        

    fetch(gsUrlApi+"empresa",{
        method: 'POST',
    
        body: formData
    })
    .then(res=>res.json())
    .then(res=>{

        console.log(res);
        /*var objUsuario = res;
        localStorage.setItem('Sesion',  JSON.stringify(objUsuario));
        window.location = 'Maqueta.html';
        cargaMenu();*/


    })
    .catch(res=>console.error(res));

}

function redireccionarVentana(objEvento, sUrl, sTitulo, sOpciones, sid_submenu) {

    var objContenedorMenu = $(objEvento).closest(".list-unstyled");
    var iid_submenu = parseInt(sid_submenu);
    var menu = sOpciones.split('|');

    var menuVentanaHab = [];

    if (gObjSesion !== null && gObjSesion.lstOpcionFunciones) {

        menuVentanaHab = gObjSesion.lstOpcionFunciones.filter(function (obj) {
            return obj.IdOpcion === iid_submenu;
        });

    }

    if (objContenedorMenu) {

        $(objContenedorMenu).find("li.active").removeClass("active");
        $(objContenedorMenu).find("a.active").removeClass("active");
        $(objEvento).addClass("active");

    }

    $("#h2_TituloPanelMaqueta").text(sTitulo);
    $("#div_btnOperaciones").find(".btn").addClass("cssOcultarObjeto");
    $("#div_btnOperaciones").find(".btn").unbind("click");
    $("#div_btnOperaciones").find(".btn").removeAttr("hab");
    $("#div_btnOperaciones").find(".btn").removeAttr("title");
    $("#div_btnOperaciones").find(".btn").attr("hab", "0");

    //mostrar botones
    for (var i = 0; i < menu.length; i++) {

        if (menu[i] !== "") {

            var objBoton = $("#div_btnOperaciones").find(".btn[operacion='" + menu[i] + "']")[0];

            if (objBoton) {

                $(objBoton).removeClass("cssOcultarObjeto");
                $(objBoton).attr("title", $(objBoton).attr("titlealt"));

            }

        }

    }

    //hab botones
    for (var i = 0; i < menuVentanaHab.length; i++) {

        if (menuVentanaHab[i].AccionesOpcion !== null && menuVentanaHab[i].AccionesOpcion) {

            var sOpcion = $.trim(menuVentanaHab[i].AccionesOpcion.split('|')[1]);

            if (sOpcion) {

                $("#div_btnOperaciones").find(".btn[operacion='" + sOpcion + "']").removeAttr("hab");
                $("#div_btnOperaciones").find(".btn[operacion='" + sOpcion + "']").attr("hab", "1");

            }

        }

    }

    if (gObjSesion !== null) {

        if (sUrl.indexOf("?") === -1) {

            sUrl = sUrl + "?IdUsuario=" + gObjSesion.user.IdUsuario + "&id_empresa=" + gObjSesion.user.id_empresa;

        } else {

            if (sUrl.indexOf("IdUsuario=") === -1) { //Agregar el QueryString IdUsuario si no esta en la url

                sUrl = sUrl + "&IdUsuario=" + gObjSesion.user.IdUsuario;

            }

            if (sUrl.indexOf("id_empresa=") === -1) { //Agregar el QueryString id_empresa si no esta en la url


                sUrl = sUrl + "&id_empresa=" + gObjSesion.user.id_empresa;

                sUrl = sUrl + "&IdEmpresa=" + gObjSesion.ObjLogin.id_empresa;


            }

        }

    }

    var objIframe = document.getElementById("iframe_BoxJob");
    if (objIframe && objIframe !== null) {

        objIframe.src = sUrl;
        gbAjustar = true;

        //Asignar acciones de los botones genericos.
        $("#div_btnOperaciones").find(".btn[hab='1']").on("click", function () {
            operacionesMenu($(this).attr("operacion"));
        });

        $("#div_btnOperaciones").find(".btn[hab='0']").removeAttr("title");
        $("#div_btnOperaciones").find(".btn[hab='0']").attr("title", "No tiene permisos para esta opción");

    }
}

function operacionesMenu(sTipo) {

    var objIframe = document.getElementById("iframe_BoxJob");

    switch (sTipo) {
        case "N":
            objIframe.contentWindow.nuevo();
            break;
        case "G":
            objIframe.contentWindow.guardar();
            break;
        case "C":
            objIframe.contentWindow.cancelar();
            break;
        case "E":
            objIframe.contentWindow.eliminar();
            break;
        case "I":
            objIframe.contentWindow.imprimir();
            break;
        case "A":
            objIframe.contentWindow.anular();
            break;
        case "PS":
            objIframe.contentWindow.siguiente();
            break;
        case "PA":
            objIframe.contentWindow.anterior();
            break;
        case "CO":
            objIframe.contentWindow.contabilizar();
            break;
        case "RG":
            objIframe.contentWindow.regenerar();
            break;
    }

}

function habilitarBotones(sBotones) {

    $("#div_btnOperaciones").find(".btn").attr("disabled", "disabled");

    if (sBotones) {

        var lstBotones = sBotones.split('|');

        for (var i = 0; i < lstBotones.length; i++) {

            if (lstBotones[i] !== "") {

                var objBoton = $("#div_btnOperaciones").find(".btn[operacion='" + lstBotones[i] + "']")[0];

                if (objBoton) {

                    if ($(objBoton).attr("hab") === "1") {
                        $(objBoton).removeAttr("disabled");
                    }
                }

            }

        }

    }

}

function cargarMenus(objSesion) {
    var navMenus = $("#nav_Menus");
    var menu;
    var subMenus;

    var arrTemp = {};
    var items = objSesion.menu;

    for (var item, i = 0; item = items[i++];) {
        if (!(item.menu_name in arrTemp)) {
            arrTemp[item.menu_name] = 1;
            subMenus = items.filter(function (obj) {
                return obj.id_menu === item.id_menu;
            });
            menu = '<ul class="list-unstyled"><li ><a href="#dropdown-' + item.menu_name + '" aria-expanded="false" data-toggle="collapse"><i class="' + item.menu_icono + '"></i><span>' + item.menu_name + '</span></a>' + cargarSubmenus(subMenus) + '</li></ul>';
            navMenus.append(menu);
        }
    }

}

function cargarSubmenus(subMenus) {
    var sResult = '';
    var arrTemp = {};

    if (subMenus.length > 0) {
        sResult += '<ul id="dropdown-' + subMenus[0].menu_name + '" class="collapse list-unstyled pt-0">';

        for (var subMenus, i = 0; item = subMenus[i++];) {
            if (!(item.submenu_name in arrTemp)) {
                arrTemp[item.submenu_name] = 1;

                if (item.activo) {

                    sResult += '<li title="' + item.submenu_name + '" ><a onclick="redireccionarVentana(this,' + '\'' + item.ruta_formulario + '\',' + '\'' + item.submenu_name + '\',' + '\'' + item.acciones_submenu + '\',' + '\'' + item.id_submenu + '\')"><i class="' + item.submenu_icono + '"></i><span>' + item.submenu_name + '</span></a></li>';

                } else {

                    sResult += '<li disabled="disabled" class="grayscale" title="' + item.submenu_name + ' (No tiene permiso para esta opción)"><a class="grayscale"><i class="' + item.submenu_icono + ' grayscale"></i><span class="grayscale">' + item.submenu_name + '</span></a></li>';

                }

            }
        }

        sResult += '</ul>';

    }

    return sResult;
}

function ajustarAltoContenidoAreaTrabajo() {

    if (gbAjustar) {

        let objIframe = document.getElementById("iframe_BoxJob");
        let iHeightAreaTrabajo = 1000;

        if (objIframe !== null) {
            let objContenidoIframe = (objIframe.contentDocument ? objIframe.contentDocument : objIframe.contentWindow.document);
            iHeightAreaTrabajo = $(objContenidoIframe).find("body").height();
            iHeightAreaTrabajo += 100;

            if ($(objContenidoIframe).find(".ui-autocomplete:visible").length > 0) {

                iHeightAreaTrabajo += $(objContenidoIframe).find(".ui-autocomplete:visible").height();

            }


            $(objIframe).height(iHeightAreaTrabajo);
            $(objIframe).css("margin-top", ($("#div_bannerTitulo").height() + 10) + "px");
            $("#div_bannerTitulo").width($(objIframe).width());

        }

    }

}

function onloadIframeAreaTrabajo() {
    var sObjetoScroll = "html, body";
    //hacemos que el scroll se ubique
    $(sObjetoScroll).animate({ scrollTop: "0px" }, 700, "swing");

    let objIframe = document.getElementById("iframe_BoxJob");

    if (objIframe !== null) {
        var objContentIframe = $(objIframe.contentDocument ? objIframe.contentDocument : objIframe.contentWindow.document);

        if (objContentIframe) {
            $(objContentIframe).find(".loader").fadeOut();
            $(objContentIframe).find("#preloader").fadeOut();
        }
    }
}


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
                        var objIframe = document.getElementById("iframe_BoxJob");
                        if (objIframe !== null) {
                            var objEvento = eval('document.getElementById("' + objIframe.id + '").contentWindow.' + $noty.options.nombreFuncion);
                            if (objEvento !== null && objEvento) {
                                objEvento($noty.options.objJsonParametro);
                                return;
                            }
                        }
                    } catch (e) { }
                    try {
                        //pagina area de trabajo
                        objEvento = eval($noty.options.nombreFuncion);
                        if (objEvento !== null && objEvento) {
                            objEvento($noty.options.objJsonParametro);
                        }
                    } catch (e) { }
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


function mostrarpopUpImpresion(sHtml, bNoMostrarBtnImp) {

    $("#div_DataImpresion").html(sHtml);

    if (bNoMostrarBtnImp) {
        $(".btnImp").addClass("cssOcultarObjeto");
    } else {
        $(".btnImp").removeClass("cssOcultarObjeto");
    }
    
    gObjPopUp = abrirPopUpBootstrap(gObjPopUp, "popup_VistapreviaImpresion");

}


function mostrarpopUp(sHtml) {

    $("#div_DataView").html(sHtml);
    gObjPopUp = abrirPopUpBootstrap(gObjPopUp, "popup_Vistaprevia");

}



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

    if (document.getElementById("iframe_BoxJob") !== null && objEvento) {
        var objPosicion = $(objEvento).position();
        var iTop = 0;

        if ((objPosicion.top - 300) > 0) {
            iTop = objPosicion.top - 300;
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
