<?php

require_once 'models/modeloGenerico.php';

class EmpresaModel extends ModeloGenerico{
    protected $id;
    protected $identificacion;
    protected $digito_verificacion;
    protected $nombre;
    protected $direccion;

    protected $telefono1;
    protected $correo;
    protected $codigo;
    protected $id_municipio;
    protected $logo;


    protected $logo_area_trabajo;
    protected $logo_login;
    protected $fecha_creacion;
    protected $id_tipo_identificacion;
    protected $telefono2;

    protected $usuario_actualizacion;

    protected $pagina_web;

    protected $celular;


    protected $meta_ventas_mensuales;
    protected $firma;
   

    protected $id_departamento;
    protected $matricula_mercantil;

    public function __construct(){
        parent::__construct("empresa",self::class);
    }

    public function setId($id){
        $this->id = $id;
    }

    public function setIdentificacion($identificacion){
        $this->identificacion = $identificacion;
    }

    public function setDigito_verificacion($digito_verificacion){
        $this->digito_verificacion = $digito_verificacion;
    }

    public function setNombre($nombre){
        $this->nombre = $nombre;
    }

    public function setDireccion($direccion){
        $this->direccion = $direccion;
    }

    public function setTelefono1($telefono1){
        $this->telefono1 = $telefono1;
    }

    public function setCorreo($correo){
        $this->correo = $correo;
    }

    public function setCodigo($codigo){
        $this->codigo = $codigo;
    }


    public function setIdMunicipio($id_municipio){
        $this->id_municipio = $id_municipio;
    }

    public function setLogo($logo){
        $this->logo = $logo;
    }

    public function setLogoAreaTrabajo($logo_area_trabajo){
        $this->logo_area_trabajo = $logo_area_trabajo;
    }
    

    public function setLogoLogin($logo_login){
        $this->logo_login= $logo_login;
    }

    public function setFecha_creacion($fecha_creacion){
        $this->fecha_creacion = $fecha_creacion;
    }

    public function setIdTipoIdentificacion($id_tipo_identificacion){
        $this->id_tipo_identificacion = $id_tipo_identificacion;
    }

    
    
    public function setTelefono2($telefono2){
        $this->telefono2 = $telefono2;
    }
    


    public function setUsuarioActualizacion($usuario_actualizacion){
        $this->usuario_actualizacion = $usuario_actualizacion;
    }

    

    public function setPaginaWeb($pagina_web){
        $this->pagina_web = $pagina_web;
    }



    //Metodos GeT

    public function getId(){
        return $this->id;
    }

    public function getOrden(){
        return $this->orden;
    }

    public function getIdentificacion(){
        return $this->identificacion;
    }

    public function getDigitoVerificacion(){
        return $this->digito_verificacion;
    }


    public function getNombre(){
        return $this->nombre;
    }

    public function getDireccion(){
        return $this->direccion;
    }


    public function getTelefono1(){
        return $this->telefono1;
    }
  
    public function getCorreo(){
        return $this->correo;
    }
    


    public function getCodigo(){
        return $this->codigo;
    }


    public function getIdMunicipio(){
        return $this->id_municipio;
    }


    public function getLogo(){
        return $this->logo;
    }


    public function getLogoAreaTrabajo(){
        return $this->logo_area_trabajo;
    }


    public function getLogoLogin(){
        return $this->logo_login;
    }


    public function getFechaCreacion(){
        return $this->fecha_creacion;
    }

    public function getIdTipoIdentificacion(){
        return $this->id_tipo_identificacion;
    }


    


    public function getTelefono2(){
        return $this->telefono2;
    }

    public function getUsuarioActualizacion(){
        return $this->usuario_actualizacion;
    }

    public function getPaginaWeb(){
        return $this->pagina_web;
    }

    public function getCelular(){
        return $this->celular;
    }

    public function getMetaVentasMensuales(){
        return $this->meta_ventas_mensuales;
    }

    public function getFirma(){
        return $this->firma;
    }

    public function getIdDepartamento(){
        return $this->id_tipo_identificacion;
    }

    public function getMatriculaMercantil(){
        return $this->id_tipo_identificacion;
    }


    
    

}

?>