<?php

require_once 'models/modeloGenerico.php';

class MenuModel extends ModeloGenerico{
    protected $id;
    protected $orden;
    protected $nombre;
    protected $icono;
    protected $descripcion;
    protected $activo;

    public function __construct(){
        parent::__construct("menu",self::class);
    }

    public function setId($id){
        $this->id = $id;
    }

    public function setOrden($orden){
        $this->orden = $orden;
    }

    public function setNombre($nombre){
        $this->nombre = $nombre;
    }

    public function setIcono($icono){
        $this->icono = $icono;
    }

    public function setDescripcion($descripcion){
        $this->descripcion = $descripcion;
    }

    public function setActivo($activo){
        $this->activo = $activo;
    }

    public function getId(){
        return $this->id;
    }

    public function getOrden(){
        return $this->orden;
    }

    public function getNombre(){
        return $this->nombre;
    }

    public function getIcono(){
        return $this->icono;
    }

    public function getDescripcion(){
        return $this->descripcion;
    }

    public function getActivo(){
        return $this->activo;
    }



}

?>