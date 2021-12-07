<?php


class TokenMiddleware{

    
    private const KEY = "mi_secret_key";
    private const ALG = "sha256";
    
    
    private function __construct(){}

    private static function base64Encode($data){
        return str_replace(['+','/','='],['-','_',''],base64_encode($data));
    }

    private static function base64Decode($data){
        return str_replace(['+','/','='],['-','_',''],base64_decode($data));
    }

    public static function getTokenRequest(){
        if(isset(explode(" ",trim(getallheaders()["Authorization"]))[1])){
            return (explode(" ",trim(getallheaders()["Authorization"]))[1]);
        }
        else{
            return null;
        }
    }

    public static function generarToken($obj,$time=0){
        
        $tiempoI = time();
        $tiempoF = ($tiempoI+$time);

        $header = self::base64Encode('{"alg": "'.self::ALG.'", "typ": "JWT"}');
        $payload = self::base64Encode('{"sub": "'.md5($tiempoI).'",'.str_replace(['{','}'],['',''],json_encode($obj)) .', "iat": '.$tiempoI.', "time": '.$tiempoF.'}');
        $signature = self::base64Encode(hash_hmac(self::ALG,$header.'.'.$payload,self::KEY,true));

        $token = $header.'.'.$payload.'.'.$signature;
        return $token;
    }

    public static function confirmarToken($token){
        if($token == null){
            return false;
        }

        $valido = false;
        $header = self::getHeader($token);
        $payload = self::getPayload($token);
        $signature = self::getSignature($token);
        $data = self::getObjectToken($token);

        if($header == null || $payload == null || $signature == null){
            return false;
        }

        $signatureOriginal =  (self::base64Encode(hash_hmac(self::ALG,self::base64Encode($header).'.'.self::base64Encode($payload),self::KEY,true)));

        if($signature == $signatureOriginal){

            if($data->time == $data->iat){
                $valido = true;
            }
            else if($data->time >= time()){
                $valido = true;
            }
            else{
                $valido = false;
            }
        }
        else{
            
            $valido = false;
        }

        return $valido;
    }

    public static function getObjectToken($token){
        return json_decode(self::getPayload($token));
    }

    private static function getPayload($token){
        
        $partesToken = explode(".",$token);
        if(count($partesToken) == 3){
            $payload = $partesToken[1];
            return self::base64Decode($payload);
        }
        else{
            return null;
        }
    }

    private static function getHeader($token){
        
        $partesToken = explode(".",$token);
        if(count($partesToken) == 3){
            $header = $partesToken[0];
            return self::base64Decode($header);
        }
        else{
            return null;
        }
        
    }

    private static function getSignature($token){
        
        $partesToken = explode(".",$token);
        if(count($partesToken) == 3){
            $signature = $partesToken[2];
            return ($signature);
        }
        else{
            return null;
        }
        
    }
}

