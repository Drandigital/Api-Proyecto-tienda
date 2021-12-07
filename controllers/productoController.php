<?php

require_once 'models/productoModel.php';

class ProductoController{

    public function __construct(){}

    public function listar($id_empresa){
        $productoModel = new ProductoModel();
        return $productoModel->findAllOption(["id_empresa"=>$id_empresa]);
    }

    public function selecionar($id_empresa,$id_producto){
        $productoModel = new ProductoModel();
        return $productoModel->findAllOption(["id"=>$id_producto,"id_empresa"=>$id_empresa],["AND"]);
    }

    public function eliminar($id_empresa,$id_producto){
        $productoModel = new ProductoModel();
        return $productoModel->deleteOption(["id"=>$id_producto,"id_empresa"=>$id_empresa],["AND"]);
    }

    public function actualizar($id_empresa,$id_producto,$obj = null){
        $productoModel = new ProductoModel();
        return $productoModel->updateOption($obj,["id"=>$id_producto,"id_empresa"=>$id_empresa],["AND"]);
    }
}
?>