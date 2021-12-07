<?php

require_once 'models/usuarioModel.php';

class AuthController{

    public function __construct(){}

    public function login($user,$pass){
        
        
        $usuarioModel = new UsuarioModel();
        
        $user = json_decode($usuarioModel->findAllOption(["user"=>$user,"pass"=>$pass],["AND"]));
        
        

        
        if($user != null){

            unset($user[0]->pass);

            $menu = json_decode($usuarioModel->Sp("cargar_menu",[$user[0]->id]));

            $data_token = ["id"=>$user[0]->id,"id_empresa"=>$user[0]->id_empresa,"tipo_user"=>$user[0]->tipo_user];
            
            header("Authorization: bearer ".TokenMiddleware::generarToken($data_token));
            
            $res = ["status"=>200,"user"=>$user[0],"menu"=>$menu];
            return json_encode($res);
            
        }
        else{

            return json_encode(["status"=>404]);

        }
        
        
    }


}
?>