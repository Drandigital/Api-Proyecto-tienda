<?php


require_once 'router/request.php';

class Uri{

    private $uri;
    private $method;
    private $function;
    private $matches;
    protected $request;
    protected $response;

    public function __construct($method,$uri,$function){
        $this->uri = $uri;
        $this->method = $method;
        $this->function = $function;
    }

    public function match($uri){
        $path = preg_replace("#:([\w]+)#",'([^/]+)',$this->uri);
        $regex = "#^$path#i";
        if(!preg_match($regex,$uri,$matches)){
            return false;
        }

        if($this->method != $_SERVER["REQUEST_METHOD"] && $this->method != "ANY"){
            return false;
        }

        array_shift($matches);
        $this->matches = $matches;
        return true;
    }

    private function parseRequest(){
        //$reflectFunction = new ReflectionMethod($this->function);
        
        $this->request = new Request($this->request);
        $this->matches[] = $this->request;
    }

    private function executeFunction(){
        $this->parseRequest();
        $this->response = call_user_func_array($this->function,$this->matches);
    }

    private function printResponse(){
        echo $this->response;
    }

    public function call(){
        try{
            $this->request = $_REQUEST;
            $this->executeFunction();
            $this->printResponse();
        }
        catch(Exception $e){
            echo "Error al llamar la Uri ".$e ;
        }
    }


}
