<?php
// no volver a requerir
require_once 'router/route.php';
require_once 'controllers/rolesController.php';



Route::get('/rol/listar/:id',function($id,Request $request){
    


    $rolesController = new RolesController();
    echo $rolesController->listar($id);
});

Route::get('/rol/seleccionar/:id',function(Request $request){
    

    $rolesController = new RolesController();
    echo $rolesController->seleccionar();
});

Route::post('/rol',function(Request $request){

    $id = $request->id;
    $descripcion = $request->descripcion;
    $id_empresa = $request->id_empresa;
    $nombre = $request->nombre;


    $obj = ["id"=>$id,"descripcion"=>$descripcion,"id_empresa"=>$id_empresa,"nombre"=>$nombre];
    $rolesController = new RolesController();
    echo $rolesController->create($obj);
});

Route::put('/rol/:id/:id_empresa/:nombre/:descripcion',function($id,$id_empresa,$nombre,$descripcion,Request $request){
    
    $obj = ["id"=>$id,"descripcion"=>$descripcion,"id_empresa"=>$id_empresa,"nombre"=>$nombre];
    
    
    $rolesController = new RolesController();
    echo $rolesController->update($obj);
});

Route::delete('/rol/:id',function($id,Request $request){

    $rolesController = new RolesController();
    echo $rolesController->delete($id);
});

