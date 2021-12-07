<?php

require_once 'router/route.php';
require_once 'controllers/productoController.php';
require_once 'middleware/tokenMiddleware.php';
require_once 'functions/funDataToken.php';

Route::get('/producto/listar',function(Request $request){
    $data = dataToken(); 
    if($data!=null){
        $productoController = new ProductoController();
        return $productoController->listar($data->id_empresa);
    }
    else{
        return "404";
    }
});

Route::get('/producto/selecionar/:id_producto',function($id,Request $request){

    $data = dataToken();
    if($data!=null){
        $productoController = new ProductoController();
        return $productoController->selecionar($data->id_empresa,$id);
    }
    else{
        return "404";
    }
});

Route::post('producto/crear',function(Request $request){
    $id = $request->id;
    $id_empresa = $request->id_empresa;
    $nombre = $request->nombre;
    $codigo = $request->codigo;
    $codigo_barra = $request->codigo_barra;
    // terminar
});







?>