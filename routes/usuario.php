<?php

require_once 'controllers/usuarioController.php';
require_once 'middleware/tokenMiddleware.php';



Route::get('/usuario/:id',function($id,Request $request){

    
    $usuarioController = new UsuarioController();
    return $usuarioController->findOne($id);
});



Route::get('/usuario',function(Request $request){

    
    $usuarioController = new UsuarioController();
    return $usuarioController->findAll();
});

Route::post('/usuario',function(Request $request){

    $id = $request->id;
    $user = $request->user;
    $pass = $request->pass;
    $id_empresa = $request->id_empresa;

    $tipo_user = $request->tipo_user;

    // comprovar si el token le pertenece a un Admin o a un superAdmin 
    // para comprovar el tipo de usuario
    $obj = ["id"=>$id,"user"=>$user,"pass"=>$pass,"id_empresa"=>$id_empresa,"tipo_user"=>$tipo_user];
    $usuarioController = new UsuarioController();
    echo $usuarioController->create($obj);
});


Route::put('/usuario/:id/:user/:pass/:id_empresa/:tipo_user',function($id,$user,$pass,$id_empresa,$tipo_user){
    

    $obj = ["id"=>$id,"user"=>$user,"pass"=>$pass,"id_empresa"=>$id_empresa,"tipo_user"=>$tipo_user];
    
    $usuarioController = new UsuarioController();
    echo $usuarioController->update($obj);
});

Route::delete('/usuario/:id',function($id,Request $request){

    $usuarioController = new UsuarioController();
    echo $usuarioController->delete($id);
});






