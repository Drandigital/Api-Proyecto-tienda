<?php
// carga todas las routes

$path_rout = "routes/";

$rutas = scandir($path_rout);

foreach($rutas as $archivo){
    
    $rutaArchivo = realpath($path_rout . $archivo);
    
    if(is_file($rutaArchivo)){
        require $rutaArchivo;
    }
}

Route::submit();
