<?php

class Request{

    protected $request;
    protected $data;
    protected $method;

    public function __construct($request,$flag = true){
        $this->request = $request;
        $this->extraerData();
        $this->setExtraerData($flag);
    }

    public function extraerData(){
        $this->data = array();
        foreach($this->request as $key => $value){
            if(is_array($value) || is_object($value)){
                $this->data[$key] = new Request($value,false);
            }
            else if($key != "http_referer"){
                $this->data[$key] = $value;
            }
        }

    }

    public function setExtraerData($flag){
        if($flag == true){
            $this->method = $_SERVER["REQUEST_METHOD"];
            $this->data["http_referer"] = isset($_SERVER["HTTP_REFERER"]) ? $_SERVER["HTTP_REFERER"] : null; 
            $heders = apache_request_headers();
            $this->data["heders"] = new Request($heders,false);

        }
    }

    public function __get($key){
        return isset($this->data[$key]) ? $this->data[$key] : null;
    }

    public function __set($key,$valor){
        $this->data[$key] = $valor;
    }

    public function all(){
        return $this->data;
    }

}
