<?php

require_once 'router/route.php';
require_once 'controllers/authController.php';

Route::post('/auth',function(Request $request){
    
    
    
    $user = $request->user;
    $pass = $request->pass;
    
    $authController = new AuthController();
    return $authController->login($user,$pass);
});



?>