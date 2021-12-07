<?php

require_once 'router/uri.php';

class Route{

    public function __construct(){}

    private static $uris = array();

    public static function add($method,$uri,$function=null){
        Route::$uris[] = new Uri($method,self::parserUri($uri),$function);

        // retornar middleware
        return;
    }

    private static function parserUri($uri){
        $uri = trim($uri,"/");
        $uri = (strlen($uri)>0) ? $uri : "/";
        return $uri;
    }

    public static function get($uri,$function = null){
        return Route::add("GET",$uri,$function);
    }

    public static function post($uri,$function = null){
        return Route::add("POST",$uri,$function);
    }

    public static function put($uri,$function = null){
        return Route::add("PUT",$uri,$function);
    }

    public static function delete($uri,$function = null){
        return Route::add("DELETE",$uri,$function);
    }

    public static function any($uri,$function = null){
        return Route::add("ANY",$uri,$function);
    }

    public static function submit(){
        $method = $_SERVER['REQUEST_METHOD'];
        $uri = isset($_GET['uri']) ? $_GET['uri'] : "";
        $uri = self::parserUri($uri);

        
        foreach(Route::$uris as $key => $recordUri){
            if($recordUri->match($uri)){
                
                return $recordUri->call();
            }
        }

        echo "No se Encuentra Registrado el Metodo ".$method;
    }


}

