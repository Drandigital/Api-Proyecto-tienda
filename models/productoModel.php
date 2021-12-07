<?php

require_once 'models/modeloGenerico.php';
class ProductoModel extends ModeloGenerico{

    protected $id;
    protected $id_empresa;
    protected $nombre;
    protected $codigo;
    protected $codigo_barra;
    protected $descripcion;
    protected $foto;
    protected $valor_unitario;
    protected $iva;

    public function __construct(){  
        parent::__construct('producto',self::class);
    }

    // getter
    public function getId(){
        return $this->id;
    }

    public function getIdEmpresa(){
        return $this->id_empresa;
    }

    public function getNombre(){
        return $this->nombre;
    }

    public function getCodigo(){
        return $this->codigo;
    }

    public function getCodigoBarra(){
        return $this->codigo_barra;
    }

    public function getDescripcion(){
        return $this->descripcion;
    }

    public function getFoto(){
        return $this->foto;
    }

    public function getValorUnitario(){
        return $this->valor_unitario;
    }

    public function getIva(){
        return $this->iva;
    }
    //setter
    
    public function setId($id){
        $this->id = $id;
    }

    public function setIdEmpresa($id_empresa){
        $this->id_empresa = $id_empresa;
    }

    public function setNombre($nombre){
        $this->nombre = $nombre;
    }

    public function setCodigo($codigo){
        $this->codigo = $codigo;
    }

    public function setCodigoBarra($codigo_barra){
        $this->codigo_barra = $codigo_barra;
    }

    public function setDescripcion($descripcion){
        $this->descripcion = $descripcion;
    }

    public function setFoto($foto){
        $this->foto = $foto;
    }

    public function setValorUnitario($valor_unitario){
        $this->valor_unitario = $valor_unitario;
    }

    public function setIva($iva){
        $this->iva = $iva;
    }
    
}
?>