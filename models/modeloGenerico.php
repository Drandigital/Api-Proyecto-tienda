<?php

require_once 'repository/factoryServicio.php';

class ModeloGenerico{
    
    private $servicioDB = null;
    private $className;
    private $model = null;

    private $excluir = ["servicioDB","className","excluir","model"];

    


    public function __construct($model,$className){
        $this->servicioDB = FactoryServicio::getInstance()->getServicio("MySQL"); 
        
        $this->model = $model; 
        $this->className = $className;
    }

    protected function getAttributos(){
        $variables = get_class_vars($this->className);
        $atributos = [];
        $max = count($variables);
        foreach($variables as $llave => $valor){
            if(!in_array($llave,$this->excluir)){
                $atributos[] = $llave;
            }
        }
        return $atributos;
    }

    protected function parsear($obj = null){
        
        try{
            $atributos = $this->getAttributos();
            $objetoFinal = [];

            if($obj == null){
                foreach($atributos as $indice => $llave){
                    if(isset($this->{$llave})){
                        $objetoFinal[$llave] = $this->{$llave};
                    }
                }
                
            }
            else{
                foreach($atributos as $indice => $llave){
                    if(isset($obj[$llave])){
                        $objetoFinal[$llave] = $obj[$llave];
                    }
                }
            }
            return $objetoFinal;
        }
        catch(Exception $e){
            throw new Exception("Error de ".$this->className." parsear() =>");
        }
    }

    public function fill($obj){
        try{
            $atributos = $this->getAttributos();
            foreach($atributos as $indice => $llave){
                if(isset($obj[$llave])){
                    $this->{$llave} = $obj[$llave];
                }
            }
        }
        catch(Exception $e){
            throw new Exception("Error fill() => ");
        }
    }

    public function findAll(){
        return $this->servicioDB->findAll($this->model);
    }

    public function findAllOption($obect_keys_values,$operators=[]){
        return $this->servicioDB->findAllOption($this->model,$obect_keys_values,$operators);
    }

    public function findOne($id){
        return $this->servicioDB->findOne($this->model,$id);
    }

    public function delete($id){
        return $this->servicioDB->delete($this->model,$id);
    }

    public function update($obj = null){
        $obj = $this->parsear($obj);
        return $this->servicioDB->update($this->model,$obj);
    }

    public function updateOption($obj,$object_keys_values,$operators=[]){
        $obj = $this->parsear($obj);
        return $this->servicioDB->updateOption($this->model,$obj,$object_keys_values,$operators);
    }

    public function deleteOption($object_keys_values,$operators=[]){
        return $this->deleteOption($object_keys_values,$operators);
    }

    public function create($obj = null){
        $obj = $this->parsear($obj);
        return $this->servicioDB->create($this->model,$obj);
    }

    public function getServicioDB(){
        return $this->servicioDB;
    }

    public function Sp($sp_name,$obj){
        
        return $this->servicioDB->Sp($sp_name,$obj);
    } 

    public function __get($nameKey){
        return $this->{$nameKey};
    }

    public function __set($nameKey,$valor){
        $this{$nameKey} = $valor;
    }

    
}

