<?php

require_once 'repository/irepository.php';

class MySQL implements Irepository{

    public static $instance = null;

    private $conexion = null;
    
    private $host = "b28vycrwfhpwv4w0ddvg-mysql.services.clever-cloud.com";
    private $name_db = "b28vycrwfhpwv4w0ddvg";
    private $user = "u5elsmgjlbf7r6w7";
    private $pass = "L6cajxDZDuS77E8TLugU";
    private $motor = "mysql";


    private function MySQL(){
        $this->connectar();
    }

    public static function getIntance(){
       
        if(self::$instance == null){
            
            return self::$instance = new MySQL();
        }
        else{
            return self::$instance;
        }
    }

    public function connectar(){
        
        try {
            
            $this->conexion = new PDO($this->motor.":host=".$this->host.";dbname=".$this->name_db,$this->user,$this->pass);
            $this->conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        } catch (PDOException $e) {
            $this->conexion = null;

            echo "¡Error!: " . $e->getMessage() . "<br/>";
            die();
        }
    }




    public function disconnect(){
        $this->conexion = null;
    }


    public function create($model,$obj){
        if(isset($obj["id"])){
            $obj["id"] = "0";
        }
        $k = implode(",",array_keys($obj));
        $v = "'".implode("', '",array_values($obj))."'";


        $sql = "INSERT INTO $model ($k) VALUES ($v)";
        

        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();
        
        if($stmt->rowCount()>0){
            return json_encode(array("create"=>1));
        }
        else{
            return json_encode(array("craete"=>0));
        }
    }


    public function update($model,$obj){
        $keys = array_keys($obj);
        $values = array_values($obj);
        $params = "";

        for($i=0; $i < count($obj);$i++){
            $params = $params.$keys[$i]." = "."'".$values[$i]."'";
            if($i != count($obj)-1){
                $params = $params.", ";
            }
        }
        
        $sql = "UPDATE $model SET $params WHERE $model.id = ".$obj["id"];
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();


        if($stmt->rowCount()>0){
            return json_encode(array("update"=>1));
        }
        else{
            return json_encode(array("update"=>0));
        }
        
    }


    public function delete($model,$id){

        $sql = "DELETE FROM $model WHERE $model.id = $id";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();


        if($stmt->rowCount()>0){
            return json_encode(array('delete'=>1));
        }
        else{
            return json_encode(array('delete'=>0));
        }

    }


    public function findAll($model){

        $sql = "SELECT * FROM $model";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();

        $data = array();
        while($row=$stmt->fetch(PDO::FETCH_ASSOC)){
            $data["all"][] = $row;
        }


        return ($data == null) ? null:json_encode($data["all"]);
    }

    

    public function findOne($model,$id){

        $sql = "SELECT * FROM $model WHERE $model.id = $id";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();

        $data = array();
        while($row=$stmt->fetch(PDO::FETCH_ASSOC)){
            $data["all"][] = $row;
        }
        
        return ($data == null) ? null:json_encode($data["all"]);

    }

    private function getWhereOption($object_keys_values,$operators){
        $option = "";
        
        if((count($object_keys_values)-1) == count($operators) && array_keys($object_keys_values)[0] != "0"){
            
            $keys = array_keys($object_keys_values);
            $values = array_values($object_keys_values);

            for($i=0;$i<count($keys);$i++){
                $option = $option.$keys[$i]."='".$values[$i]."' ";
                if($i < count($operators)){
                    $option = $option.$operators[$i]." ";
                }
            }

        }
        return $option;
        
    }

    public function findAllOption($model,$object_keys_values,$operators){
        $option = $this->getWhereOption($object_keys_values,$operators);
        
        
        if($option != ""){
            
            $sql = "SELECT * FROM $model WHERE $option";
            
            $stmt = $this->conexion->prepare($sql);
            $stmt->execute();

            $data = array();
            while($row=$stmt->fetchAll(PDO::FETCH_ASSOC)){
                $data["all"] = $row;
            }
            return ($data == null) ? null : json_encode($data["all"]);
        }
        else{
            return null;
        }

    }

    public function updateOption($model,$obj,$object_keys_values,$operators){
        
        $option = $this->getWhereOption($object_keys_values,$operators);

        if($option == ""){
            return json_encode(array("update"=>0));
        }

        $keys = array_keys($obj);
        $values = array_values($obj);
        $params = "";

        for($i=0; $i < count($obj);$i++){
            $params = $params.$keys[$i]." = "."'".$values[$i]."'";
            if($i != count($obj)-1){
                $params = $params.", ";
            }
        }
        
        $sql = "UPDATE $model SET $params WHERE $option";
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();


        if($stmt->rowCount()>0){
            return json_encode(array("update"=>1));
        }
        else{
            return json_encode(array("update"=>0));
        }
    }

    public function deleteOption($model,$object_keys_values,$operators){
        
        $option = $this->getWhereOption($object_keys_values,$operators);
        
        if($option == ""){
            return json_encode(array('delete'=>0));
        }

        $sql = "DELETE FROM $model WHERE $option";
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();


        if($stmt->rowCount()>0){
            return json_encode(array('delete'=>1));
        }
        else{
            return json_encode(array('delete'=>0));
        }
    }

    public function Sp($sp_name,$obj){
        
        $values = "'".implode("', '",array_values($obj))."'";
        $sql = "call $sp_name($values)";

       
        
        $stmt = $this->conexion->prepare($sql);
        $stmt->execute();

        $data = array();
        while($row=$stmt->fetchAll(PDO::FETCH_ASSOC)){
            $data["all"] = $row;
        }
        
        
        return ($data == null) ? null : json_encode($data["all"]);
    }


}


