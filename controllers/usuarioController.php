<?php

require_once 'models/usuarioModel.php';


class UsuarioController{

    public function __construct(){}

    public function findAll(){
        
        

        $usaurioModel = new UsuarioModel();
        return $usaurioModel->findAll();
    }

    public function findOne($id){
        $usuarioModel = new UsuarioModel();
        return $usuarioModel->findOne($id);
    }


    public function update($obj = null){
        $usuarioModel = new UsuarioModel();
        return $usuarioModel->update($obj);
    } 

    public function updateOption($obj,$user){

        $usuarioModel = new UsuarioModel();
        return $usuarioModel->updateOption($obj,[]);
    }

    public function create($obj = null){
        
        $usuarioModel = new UsuarioModel();
        return $usuarioModel->create($obj);
    }

    public function delete($id){
        $usuarioModel = new UsuarioModel();
        return $usuarioModel->delete($id);
    }

    public function findAllOption($user){


        $usuarioModel = new UsuarioModel();
        return $usuarioModel->findAllOption(["user"=>$user]);
    }

    
}

