<?php
require_once 'middleware/tokenMiddleware.php';

function dataToken(){
    $token = TokenMiddleware::getTokenRequest();
    if($token != null){
        if(TokenMiddleware::confirmarToken($token)){
            return TokenMiddleware::getObjectToken($token);
        }
        else{
            return null;
        }
    }
    else{
        return null;
    }
}

?>