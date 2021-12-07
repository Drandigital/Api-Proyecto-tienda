<?php

require_once 'models/modeloGenerico.php';

class RolesModel extends ModeloGenerico{


    protected $id;
    protected $id_empresa;
    protected $nombre;
    protected $descripcion;
    
    public function __construct(){
        parent::__construct("rol",self::class);
    }

    public function setId($id){
        $this->id = $id;
    }

    public function setIdEmpresa($id_empresa){
        $this->id_empresa = $id_empresa;
    }

    public function setNombre($nombre){
        $this->nombre = $nombre;
    }

    public function setDescripcion($descripcion){
        $this->descripcion = $descripcion;
    }

    public function getId(){
        return $this->id;
    }

    public function getIdEmpresa(){
        return $this->id_empresa;
    }

    public function getNombre(){
        return $this->nombre;
    }

    public function getDescripcion(){
        return $this->descripcion;
    }



    

}

