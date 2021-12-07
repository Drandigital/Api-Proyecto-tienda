<?php
// no volver a requerir
require_once 'router/route.php';
require_once 'controllers/permisosController.php';



Route::get('/permiso/listar/:id',function($id,Request $request){
    
    $permisosController = new RolesController();
    echo   $permisosController->listar($id);
});



