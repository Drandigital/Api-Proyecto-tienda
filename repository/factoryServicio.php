<?php

require_once 'factoryRepository.php';

class FactoryServicio{

    public static $instance = null;

    private function FactoryServicio(){}

    public static function getInstance(){
        if(self::$instance == null){
            return self::$instance = new FactoryServicio();
        }
        else{
            return self::$instance;
        }
    }

    public function getServicio($tipe){
        switch($tipe){
            case "MySQL":
                return FactoryRepository::getInstance()->getDB("MySQL");
                break;
            default:
                return FactoryRepository::getInstance()->getDB("MySQL");
                
        }
    }

}

