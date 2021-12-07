<?php

require_once 'database/mysql.php';


class FactoryRepository{

    public static $instance = null;


    private function FactoryRepository(){}

    public static function getInstance(){
        if(self::$instance == null){
            return self::$instance = new FactoryRepository();
        }
        else{
            return self::$instance;
        }
    }

    
    public function getDB($tipe){
        switch($tipe){
            case "MySQL":
                return MySQL::getIntance();
                break;

            default:
                return MySQL::getIntance();
                
        }
    }




}

