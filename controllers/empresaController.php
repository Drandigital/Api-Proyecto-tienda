<?php
require_once 'models/empresaModel.php';

class EmpresaController{

    public function __construct(){}

    public function findOne($id){
        $empresaModel = new EmpresaModel();
        return $empresaModel->findOne($id);
    }

}
?>