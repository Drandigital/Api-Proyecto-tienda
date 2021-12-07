<?php

require_once 'database/mysql.php';

class ServicioMySQL{

    public static $instance = null;
    private $mySQL = null;


    private function ServicioMySQL(){
        $this->mySQL = MySQL::getIntance();
        
    }

    public static function getInstance(){
        
        if(self::$instance == null){
            return self::$instance = new ServicioMySQL();
        }
        else{
            return self::$instance;
        }
    }

    public function connectar(){
        $this->mySQL->connectar();
    }

    public function disconnect(){
        $this->disconnect();
    }

    public function findAll($model){
        return (($this->mySQL->findAll($model)));
    }

    public function findOne($model,$id){
        return (($this->mySQL->findOne($model,$id)));
    }

    public function delete($model,$id){
        return (($this->mySQL->delete($model,$id)));
    }

    public function update($model,$obj){
        return (($this->mySQL->update($model,$obj)));
    }

    public function create($model,$obj){
        return (($this->mySQL->create($model,$obj)));
    }

    public function findAllOption($model,$object_keys_values,$operators){
        return (($this->mySQL->findAllOption($model,$object_keys_values,$operators)));
    }

    public function updateOption($model,$obj,$object_keys_values,$operators){
        return (($this->mySQL->updateOption($model,$obj,$object_keys_values,$operators)));
    }

    public function deleteOption($model,$object_keys_values,$operators){
        return (($this->mySQL->deleteOption($model,$object_keys_values,$operators)));
    }

    public function Sp($sp_name,$obj){
        
        return ($this->mySQL->Sp($sp_name,$obj));
    }
}

