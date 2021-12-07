<?php

require_once 'router/route.php';
require_once 'controllers/empresaController.php';

Route::post('/empresa',function(Request $request){
    $id = $request->id;

    
    $empresaController = new EmpresaController();
    return $empresaController->findOne($id);
});



?>