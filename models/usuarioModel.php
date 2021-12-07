<?php

require_once 'models/modeloGenerico.php';


class UsuarioModel extends ModeloGenerico{

    protected $id;
    protected $id_empresa;
    protected $primer_nombre;
    protected $segundo_nombre;
    protected $primer_apellido;
    protected $segundo_apellido;
    protected $identificacion;
    protected $user;
    protected $pass;
    protected $id_tipo_identificacion;
    protected $id_pais;
    protected $id_departamento;
    protected $id_municipio;
    protected $id_rol;
    protected $direccion;
    protected $correo;
    protected $celular;
    protected $telefono;
    protected $activo;
    protected $foto;
    protected $id_usuario_registro;
    protected $fecha_registro;
    protected $fecha_actualizacion;
    protected $tipo_user;

    
    public function __construct(){
        parent::__construct('usuario',self::class);
    }

    
    public function setId($id){
        $this->id = $id;
    }

    

    public function setUser($user){
        $this->user = $user;
    }

    
    public function setPass($pass){
        $this->pass = $pass;
    }

    
    public function setIdEmpresa($id_empresa){
        $this->id_empresa = $id_empresa;
    }

    
    public function setTipoUser($tipo_user){
        $this->tipo_user = $tipo_user;
    }

    public function getId(){
        return $this->id;
    }

    
    public function getUser(){
        return $this->user;
    }

    
    public function getPass(){
        return $this->pass;
    }

    
    public function getIdEmpresa(){
        return $this->id_empresa;
    }

    
    public function getTipoUser(){
        return $this->tipo_user;
    }


}

