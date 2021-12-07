var giIdRol = 1;
var gsNombre = "";
var gsDescripcion = "";
var ObjTable = null;
var giIdEmpresa = obtenerQueryString("id_empresa");
var giIdRol = obtenerQueryString("id_rol");

inicializarVentana();

function inicializarVentana() {

    ObtenerDatos();
    parent.habilitarBotones("|N|");

}

function ObtenerDatos() {
    
    
        

    fetch(gsUrlApi+"rol/listar/"+ giIdEmpresa ,{
        method: 'GET',
    
     
    })
    .then(res=>res.json())
    .then(res=>{
        
        var lstData = [];

        for(var i = 0 ; i < res.length ; i++ ){

            var objData = new Object();
            objData.IdRol = res[i].id;
            objData.Nombre = res[i].nombre;
            objData.Descripcion = res[i].descripcion;
            lstData.push(objData);


     
        }

        ArmarDataTable(lstData);




    })
    .catch(res=>console.log(res));


}

function ArmarDataTable(ObjDatos) {
    if (ObjDatos !== null && ObjDatos != undefined) {

        ObjTable = $('#table_Lista').DataTable({
            data: ObjDatos,
            columns: [
                { data: 'Nombre', title: 'Nombre', className: 'text-center', width: '30%' },
                { data: 'Descripcion', title: 'Descripción', className: 'text-center', width: '70%' }
            ],
            language: {
                sProcessing: "Procesando...",
                sLengthMenu: "Mostrar _MENU_ registros",
                sZeroRecords: "No se encontraron resultados",
                sEmptyTable: "Ningún dato disponible en esta tabla",
                sInfo: "Del _START_ al _END_ total ( _TOTAL_ ) registros",
                sInfoEmpty: "Mostrando registros del 0 al 0 de un total de 0 registros",
                sInfoFiltered: "(filtrado de un total de _MAX_ registros)",
                sInfoPostFix: "",
                sSearch: "Buscar:",
                sUrl: "",
                sInfoThousands: ",",
                sLoadingRecords: "Cargando...",
                oPaginate: {
                    sFirst: "Primero",
                    sLast: "Último",
                    sNext: "Siguiente",
                    sPrevious: "Anterior"
                },
                oAria: {
                    "sSortAscending": ": Activar para ordenar la columna de manera ascendente",
                    "sSortDescending": ": Activar para ordenar la columna de manera descendente"
                }
            },
            responsive: true,
            autoWidth: false,
            lengthMenu: [[5], [5]],
            select: {
                style: 'single'
            }
        });

        $('#table_Lista').find('tbody tr').attr("title", "Dar click para editar");

    } else {
        limpiarFormulario();
    }

}

$('#table_Lista').on('click', 'tbody tr', function () {
    if (ObjTable.row(this).data().IdRol != undefined && ObjTable.row(this).data().IdRol != null) {
        mostrarFormulario(true);
        console.log(ObjTable.row(this).data());
        ConsultarEditar(ObjTable.row(this).data().IdRol,  ObjTable.row(this).data().Nombre, ObjTable.row(this).data().Descripcion );
    }
});

function ConsultarEditar(IdRole, Nombre, Descripcion) {


    $("#input_Nombre").val(Nombre);
    $("#textarea_Descripcion").val(Descripcion);

    consultarPermisos();
  
}

function eliminar() {

    var sIdRegistro = giIdRol;

    if (sIdRegistro) {

        mostrarAlertas("¿Desea eliminar el registro seleccionado?", "confirm", undefined, undefined, "Si", "No", "quitarRegistro", sIdRegistro);

    } else {

        mostrarAlertas("Error al obtener dato para eliminar el rol.", "error");

    }

}

function quitarRegistro(sIdRol) {
    $.ajax({
        type: "POST",
        url: gsUrlApi + "/Roles/Eliminar?IdRol=" + sIdRol,
        headers: gsAutenticacion,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (result) {
            if (result.Error) {
                mostrarAlertas(result.Mensaje, "error");
                return;
            }

            mostrarAlertas(result.Mensaje, "success");
            cancelar();

        },
        error: function (e) {
            mostrarAlertas("Error en ajax al eliminar rol.", "error");
        }
    });
}


function nuevo() {

    mostrarFormulario(true);
    consultarPermisos();
    parent.habilitarBotones("|G|C|");

}

function cancelar() {

    mostrarFormulario(false);

}

function mostrarFormulario(bMostrar) {

    limpiarFormulario();

    if (bMostrar) {

        $(".btnFormulario").removeClass("cssOcultarObjeto");
        $(".btnLista").addClass("cssOcultarObjeto");
        parent.habilitarBotones("|G|C|E|");

    } else {

        $(".btnFormulario").addClass("cssOcultarObjeto");
        $(".btnLista").removeClass("cssOcultarObjeto");
        parent.habilitarBotones("|N|");
        $("#table_Lista").dataTable().fnDestroy();
        ObtenerDatos();

    }
}

function obtenerPermisosTree() {
    var lstPermisos = $('#jstree').jstree(true).get_json();
    var sXmlPermisos = "";

    for (var i = 0; i < lstPermisos.length; i++) {

        var objMenu = lstPermisos[i];

        for (var j = 0; j < objMenu.children.length; j++) {

            var objSubMenu = objMenu.children[j];

            for (var k = 0; k < objSubMenu.children.length; k++) {

                var objOpcion = objSubMenu.children[k];

                if (objOpcion.state.selected) {

                    sXmlPermisos += "<Permiso>";
                    sXmlPermisos += "<Rol>" + giIdRol + "</Rol>";
                    sXmlPermisos += "<Opcion>" + objOpcion.id.split('_')[2] + "</Opcion>";
                    sXmlPermisos += "</Permiso>";

                }

            }

        }

    }

    return "<Permisos>" + sXmlPermisos + "</Permisos>";

}

function guardar() {

    try {

        parent.habilitarBotones();

        if (ValidarCamposJson("#div_Formulario")) {

            var ObjDatos = new Object();
            ObjDatos.IdRol = giIdRol !== 0 ? giIdRol : null;
            ObjDatos.IdEmpresa = giIdEmpresa;
            ObjDatos.Nombre = $("#input_Nombre").val();
            ObjDatos.Descripcion = $("#textarea_Descripcion").val();
            ObjDatos.Permisos = window.btoa(obtenerPermisosTree());
            ObjDatos.accion = "Guardar";

           

            $.ajax({
                url: '../../../controlador/roles.controlador.php',
                data: ObjDatos,
                type: 'POST',
                dataType: 'json',
            }).done(function (result) {
             

                if (result.Error) {
                    mostrarAlertas(result.Mensaje, "error");
                    parent.habilitarBotones("|G|C|E|");
                    return;
                }

                mostrarAlertas(result.Mensaje, "success");
                cancelar();

                
                
            }).fail(function (e){
                mostrarAlertas("Error en ajax al guardar rol.", "error");
                parent.habilitarBotones("|G|C|E|");

            });
        } else {
            parent.habilitarBotones("|G|C|E|");
        }
    } catch (ex) {
        mostrarAlertas("Error en GuardarMaestro():\n" + ex.message, 'error');
        parent.habilitarBotones("|G|C|E|");
    }
}

function limpiarFormulario() {
    giIdRol = 1;
    $("#input_Nombre").val("");
    $("#textarea_Descripcion").val("");
}


function seleccionarTodos(objEvento) {

    if (objEvento.checked) {

        $('#jstree').jstree(true).select_all();

    } else {

        $('#jstree').jstree(true).deselect_all();

    }

}




function consultarPermisos() {

    fetch(gsUrlApi+"permiso/lista/"+ giIdRol  ,{
        method: 'GET',
    
     
    })
    .then(res=>res.json())
    .then(res=>{


        lstDataPermisos = JSON.parse(res);

        for (var i = 0; i < lstDataPermisos.length; i++) {

            lstDataPermisos[i].state = { "opened": true, "selected": lstDataPermisos[i].selected };

        }

        inicializarTreePermisos(lstDataPermisos);




    })
    .catch(res=>console.log(res));
    
}

function inicializarTreePermisos(lstData) {

    $("#jstree").jstree('destroy');
    $('#jstree').jstree({
            'core': {
                'data': lstData
            }
            , 'plugins': ['checkbox']

    });

    //$('#jstree').jstree(true).open_all();

}

