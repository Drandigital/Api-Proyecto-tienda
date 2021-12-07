
$('#contrasenia').keypress(function (event) {
    var keycode = (event.keyCode ? event.keyCode : event.which);
    if (keycode == 13) {
        login();
    }
});

function login() {

    $(".loader").fadeIn();
    $("#preloader").fadeIn();

    setTimeout(IniciarSesion, 200);
    
}

function IniciarSesion() {
    var usuario = document.getElementById('correo').value;
    var contrasena = document.getElementById('contrasenia').value;
    var formData = new FormData();
    if (usuario == "") {
        alert('Debe ingresar usuario');
        return;
    }

    if (contrasena == "") {
        alert('Debe ingresar contraseña');
        return;
    }

    formData.append("user",usuario);
    formData.append("pass",contrasena);

    console.log(gsUrlApi+"auth");
    fetch(gsUrlApi+"auth",{
        method: 'POST',
        mode: 'cors',
        credentials: 'same-origin',
        headers:{
            'Accept':'application/json'
        },
        body: formData
    })
    .then(res=>{
        for(var k of res.headers.keys()){
            console.log(k);
        }
        
        var token = res.headers.get('Authorization');
 
        var tokenUser = token;
        localStorage.setItem('Token',  JSON.stringify(tokenUser));
        
        return res.json();
    })
    .then(res=>{
        
        var objUsuario = res;
        localStorage.setItem('Sesion',  JSON.stringify(objUsuario));
        window.location = 'Maqueta.html';
        cargaMenu();


    })
    .catch(res=>console.log(res));


}

function cargaMenu() {
 
    
    fetch(gsUrlApi+"menu",{
        method: 'GET',
    })
    .then(res=>res.json())
    .then(res=>{


        console.log(res);


    })
    .catch(res=>console.error(res));


}