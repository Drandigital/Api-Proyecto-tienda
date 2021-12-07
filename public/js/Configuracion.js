var gsUrlApi;

var sAmbiente = "DEBUG";

switch (sAmbiente) {
    case "DESARROLLO":
        gsUrlApi = "http://localhost:8024/tienda/tienda/";
        break;
    case "PRODUCCION":
        gsUrlApi = "http://localhost:8024/apifacturacion";
        break;
    default:
        gsUrlApi = "http://localhost:8024/tienda/tienda/";
}
