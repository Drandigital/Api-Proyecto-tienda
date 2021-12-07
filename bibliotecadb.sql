-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-06-2021 a las 17:49:19
-- Versión del servidor: 10.4.18-MariaDB
-- Versión de PHP: 7.3.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bibliotecadb`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `cargar_menu` (IN `id_login` INT(1))  BEGIN

SELECT 
    M.nombre as menu_name, 
    M.orden as menu_orden, 
    M.id as id_menu, 
    M.icono as menu_icono, 
    S.nombre as submenu_name, 
    S.orden as submenu_orde, 
    S.icono as submenu_icono, 
    S.ruta_formulario, 
    S.id as id_submenu, 
    S.activo,
    S.acciones
FROM menu as M 
    LEFT OUTER JOIN submenu as S ON  M.id = S.id_menu ;



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_login` (IN `usur_login` VARCHAR(20), IN `user_clave` VARCHAR(20))  BEGIN
    
            SELECT 
				U.primer_nombre
				,U.foto
				,U.id
				,U.tipo_user AS tipo_user

			FROM usuario AS U
				INNER JOIN rol AS R ON R.id = U.id_rol
				INNER JOIN permiso AS P ON P.id_rol = R.id 
			WHERE U.user = usur_login AND U.pass = user_clave;
           /* SELECT 
				 M.id
				,M.nombre AS NombreMenu
				,M.icono AS IconoMenu
				,M.orden AS OrdenMenu
				,IFNULL(SM.id, 0) AS IdSubMenu
				,SM.nombre AS NombreSubMenu
				,SM.ruta_formulario AS FormularioSubMenu
				,IFNULL(SM.orden, 0) AS OrdenSubMenu
				,MAX(CASE 
						WHEN U.id IS NULL OR IFNULL(SM.activo, 0) = 0 
						THEN 0 
						ELSE 1 
					END) AS 'ActivoSubMenu'
				, IFNULL(SM.icono,'la la-tags') AS 'IconoSubMenu'
				, SM.acciones AS 'AccionesSubMenu'
			FROM menu AS M
				LEFT OUTER JOIN submenu AS SM ON M.id = SM.id_menu
				LEFT OUTER JOIN submenuopcion AS SMO ON SM.id = SMO.id_sub_menu
				LEFT OUTER JOIN permiso AS P ON  SMO.id = P.id_opcion_sub_menu 
				LEFT OUTER JOIN usuario AS U ON P.id_rol = U.id_rol AND U.user  = usur_login AND U.pass = user_clave
                
                GROUP BY M.id
				,M.nombre 
				,M.icono
				,M.orden 
				,SM.id
				,SM.nombre 
				,SM.ruta_formulario
				,SM.orden 
				,SM.icono
				,SM.acciones
                
			ORDER BY M.orden, 
            		 SM.orden;
            
            	SELECT SMO.id_sub_menu AS 'IdOpcion'
				, SMO.nombre AS NombreOpcion
				, SMO.accion AS 'AccionesOpcion'
			FROM submenuopcion AS SMO
				INNER JOIN permiso AS P ON SMO.id = P.id_opcion_sub_menu  
				INNER JOIN usuario AS U ON P.id_rol = U.id_rol 
			WHERE SMO.activo = 1 AND U.user  = usur_login AND U.pass = user_clave 
			ORDER BY SMO.id_sub_menu;*/
    END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_opciones` (IN `id_user` INT)  BEGIN

    SELECT 
        SMO.id_sub_menu AS 'IdOpcion'
        ,SMO.nombre AS 'NombreOpcion'
        ,SMO.accion AS 'AccionesOpcion'
    FROM submenuopcion AS SMO
    LEFT JOIN permiso AS P ON SMO.id = P.id_submenu_opcion  
    
    LEFT JOIN usuario AS U ON P.id_rol = U.id_rol ;
    
  



END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Permisos` (IN `id_rol` INT)  BEGIN
	
		CREATE TEMPORARY TABLE IF NOT EXISTS tempPermisos (
			   id VARCHAR(100),
			   text		VARCHAR(100),  
			   icon			VARCHAR(100), 
			   parent		VARCHAR(100), 
			   selected      BIT
			   );

		INSERT INTO tempPermisos
		SELECT 
			id	AS 'id'
			,nombre	AS 'text'
			,icono AS 'icon'
			, '#' AS 'parent'
			, 0 AS selected
		FROM menu 
        ORDER BY Orden;


		INSERT INTO tempPermisos
		SELECT 
			CONCAT(S.id_menu  ,"_" , S.id)  AS 'id'
			,nombre	AS 'text'
			,IFNULL(icono, 'la la-list') AS 'icon'
			, id_menu AS 'parent'
			, 1 AS selected
		FROM submenu   S
		ORDER BY Orden;
 
 
		INSERT INTO tempPermisos
		SELECT 
        CONCAT(S.id_menu  ,"_" , S.id  , "_" , SO.id)  AS 'id'
			,SO.nombre	AS 'text'
			,IFNULL(SO.icono, 'la la-list') AS 'icon'
			, CONCAT( S.id_menu , '_' , S.id ) AS 'parent'
			, CASE WHEN P.id IS NOT NULL THEN  1 ELSE 0 END AS selected
		FROM submenuopcion SO 
			INNER JOIN  submenu S ON SO.id_sub_menu = S.id
			LEFT JOIN permiso P  ON P.id_rol = id_rol AND SO.id = P.id_submenu_opcion;

		SELECT * FROM  tempPermisos;

		DROP TABLE tempPermisos;
	 

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bodega`
--

CREATE TABLE `bodega` (
  `id` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(250) NOT NULL,
  `id_user` int(11) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `bodega`
--

INSERT INTO `bodega` (`id`, `id_empresa`, `nombre`, `descripcion`, `id_user`, `fecha_creacion`) VALUES
(2, 1, 'prueba 2', 'sadlasjdlksajdlas', 1, '2021-05-07 16:34:35'),
(3, 1, 'prueva 3', 'sadsadsadasd', 1, '2021-05-07 16:34:35');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `id` varchar(2) NOT NULL,
  `codigo` varchar(5) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `indicativo` varchar(3) DEFAULT NULL,
  `codigo_postal` varchar(3) DEFAULT NULL,
  `id_pais` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `departamento`
--

INSERT INTO `departamento` (`id`, `codigo`, `nombre`, `indicativo`, `codigo_postal`, `id_pais`) VALUES
('05', NULL, 'Antioquia', NULL, NULL, '169'),
('08', NULL, 'Atlántico', NULL, NULL, '169'),
('11', NULL, 'Botá D.C', NULL, NULL, '169'),
('13', NULL, 'Bolívar', NULL, NULL, '169'),
('15', NULL, 'Boyacá', NULL, NULL, '169'),
('17', NULL, 'Caldas', NULL, NULL, '169'),
('18', NULL, 'Caquetá', NULL, NULL, '169'),
('19', NULL, 'Cauca', NULL, NULL, '169'),
('20', NULL, 'Cesar', NULL, NULL, '169'),
('23', NULL, 'Córdoba', NULL, NULL, '169'),
('25', NULL, 'Cundinamarca', NULL, NULL, '169'),
('27', NULL, 'Chocó', NULL, NULL, '169'),
('41', NULL, 'Huila', NULL, NULL, '169'),
('44', NULL, 'La Guajira', NULL, NULL, '169'),
('47', NULL, 'Magdalena', NULL, NULL, '169'),
('50', NULL, 'Meta', NULL, NULL, '169'),
('52', NULL, 'Nariño', NULL, NULL, '169'),
('54', NULL, 'Norte de Santander', NULL, NULL, '169'),
('63', NULL, 'Quindio', NULL, NULL, '169'),
('66', NULL, 'Risaralda', NULL, NULL, '169'),
('68', NULL, 'Santander', NULL, NULL, '169'),
('70', NULL, 'Sucre', NULL, NULL, '169');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `id` int(11) NOT NULL,
  `identificacion` varchar(20) NOT NULL,
  `digito_verificacion` char(1) NOT NULL,
  `nombre` varchar(200) NOT NULL,
  `direccion` varchar(200) NOT NULL,
  `telefono1` varchar(20) NOT NULL,
  `correo` varchar(200) NOT NULL,
  `codigo` varchar(200) DEFAULT NULL,
  `id_municipio` varchar(5) NOT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `logo_area_trabajo` varchar(255) DEFAULT NULL,
  `logo_login` varchar(255) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT NULL,
  `id_tipo_id_entificacion` int(11) DEFAULT NULL,
  `telefono2` varchar(20) DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT NULL,
  `usuario_actualizacion` int(11) DEFAULT NULL,
  `pagina_web` varchar(250) DEFAULT NULL,
  `activo` bit(1) DEFAULT NULL,
  `celular` varchar(20) DEFAULT NULL,
  `meta_ventas_mensual` decimal(19,4) DEFAULT NULL,
  `firma` varchar(250) DEFAULT NULL,
  `leyenda_factura` varchar(1000) DEFAULT NULL,
  `tipo_comprobante_factura_venta` varchar(50) DEFAULT NULL,
  `codigo_tipo_responsabilidad` varchar(50) DEFAULT NULL,
  `cuenta_iva` varchar(20) DEFAULT NULL,
  `id_departamento` int(11) DEFAULT NULL,
  `matricula_mercantil` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `empresa`
--

INSERT INTO `empresa` (`id`, `identificacion`, `digito_verificacion`, `nombre`, `direccion`, `telefono1`, `correo`, `codigo`, `id_municipio`, `logo`, `logo_area_trabajo`, `logo_login`, `fecha_creacion`, `id_tipo_id_entificacion`, `telefono2`, `fecha_actualizacion`, `usuario_actualizacion`, `pagina_web`, `activo`, `celular`, `meta_ventas_mensual`, `firma`, `leyenda_factura`, `tipo_comprobante_factura_venta`, `codigo_tipo_responsabilidad`, `cuenta_iva`, `id_departamento`, `matricula_mercantil`) VALUES
(1, '806014869', '8', 'SERVICIOS INTEGRADOS SI LTDA', 'SAN FERNANDO', '3145935235', 'frainer2013@gmail.com', '', '13001', 'Logo.jpg', 'LogoAreaTrabajo.jpg', 'LogoLogin.jpg', NULL, 31, '6910274', '2020-09-09 20:23:56', 3, 'tiserium.com', b'1', '3128436036', '10000000.0000', 'Firma.jpg', '', '', NULL, '', 13, '121212');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `genero`
--

CREATE TABLE `genero` (
  `id` int(50) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `genero`
--

INSERT INTO `genero` (`id`, `id_empresa`, `nombre`, `descripcion`) VALUES
(1, 1, 'Fantasia', 'Genero de fantasia'),
(2, 1, 'Terror', 'Genero de terror');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `libro`
--

CREATE TABLE `libro` (
  `id` int(50) NOT NULL,
  `id_empresa` int(50) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` int(250) NOT NULL,
  `foto` mediumtext NOT NULL,
  `genero` varchar(100) NOT NULL,
  `fecha_publicacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu`
--

CREATE TABLE `menu` (
  `id` tinyint(4) NOT NULL,
  `orden` tinyint(4) DEFAULT NULL,
  `nombre` varchar(50) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `icono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `menu`
--

INSERT INTO `menu` (`id`, `orden`, `nombre`, `descripcion`, `icono`) VALUES
(1, 1, 'Dashboard', 'Panel principal del software', 'la la-calculator'),
(3, 9, 'Configuracion', 'Configuracion', 'la la-cogs'),
(4, 3, 'Gestionar', 'Gestionar', 'la la-file-text');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `municipio`
--

CREATE TABLE `municipio` (
  `id` varchar(5) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `indicativo` varchar(3) DEFAULT NULL,
  `codigo_postal` varchar(3) DEFAULT NULL,
  `id_departamento` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `municipio`
--

INSERT INTO `municipio` (`id`, `nombre`, `indicativo`, `codigo_postal`, `id_departamento`) VALUES
('05001', 'Medellín', NULL, NULL, '05'),
('05002', 'Abejorral', NULL, NULL, '05'),
('05004', 'Abriaquí', NULL, NULL, '05'),
('05021', 'Alejandría', NULL, NULL, '05'),
('05030', 'Amagá', NULL, NULL, '05'),
('05031', 'Amalfi', NULL, NULL, '05'),
('05034', 'Andes', NULL, NULL, '05'),
('05036', 'Angelópolis', NULL, NULL, '05'),
('05038', 'Anstura', NULL, NULL, '05'),
('05040', 'Anorí', NULL, NULL, '05'),
('05042', 'Santafé de antioquia', NULL, NULL, '05'),
('05044', 'Anza', NULL, NULL, '05'),
('05045', 'Apartadó', NULL, NULL, '05'),
('05051', 'Arboletes', NULL, NULL, '05'),
('05055', 'Argelia', NULL, NULL, '05'),
('05059', 'Armenia', NULL, NULL, '05'),
('05079', 'Barbosa', NULL, NULL, '05'),
('05086', 'Belmira', NULL, NULL, '05'),
('05088', 'Bello', NULL, NULL, '05'),
('05091', 'Betania', NULL, NULL, '05'),
('05093', 'Betulia', NULL, NULL, '05'),
('05101', 'Ciudad bolívar', NULL, NULL, '05'),
('05107', 'Briceño', NULL, NULL, '05'),
('05113', 'Buriticá', NULL, NULL, '05'),
('05120', 'Cáceres', NULL, NULL, '05'),
('05125', 'Caicedo', NULL, NULL, '05'),
('05129', 'Caldas', NULL, NULL, '05'),
('05134', 'Campamento', NULL, NULL, '05'),
('05138', 'Cañasrdas', NULL, NULL, '05'),
('05142', 'Caracolí', NULL, NULL, '05'),
('05145', 'Caramanta', NULL, NULL, '05'),
('05147', 'Carepa', NULL, NULL, '05'),
('05148', 'El carmen de viboral', NULL, NULL, '05'),
('05150', 'Carolina', NULL, NULL, '05'),
('05154', 'Caucasia', NULL, NULL, '05'),
('05172', 'Chirodó', NULL, NULL, '05'),
('05190', 'Cisneros', NULL, NULL, '05'),
('05197', 'Cocorná', NULL, NULL, '05'),
('05206', 'Concepción', NULL, NULL, '05'),
('05209', 'Concordia', NULL, NULL, '05'),
('05212', 'Copacabana', NULL, NULL, '05'),
('05234', 'Dabeiba', NULL, NULL, '05'),
('05237', 'Don matías', NULL, NULL, '05'),
('05240', 'Ebéjico', NULL, NULL, '05'),
('05250', 'El bagre', NULL, NULL, '05'),
('05264', 'Entrerrios', NULL, NULL, '05'),
('05266', 'Envigado', NULL, NULL, '05'),
('05282', 'Fredonia', NULL, NULL, '05'),
('05284', 'Frontino', NULL, NULL, '05'),
('05306', 'Giraldo', NULL, NULL, '05'),
('05308', 'Girardota', NULL, NULL, '05'),
('05310', 'Gómez plata', NULL, NULL, '05'),
('05313', 'Granada', NULL, NULL, '05'),
('05315', 'Guadalupe', NULL, NULL, '05'),
('05318', 'Guarne', NULL, NULL, '05'),
('05321', 'Guatape', NULL, NULL, '05'),
('05347', 'Heliconia', NULL, NULL, '05'),
('05353', 'Hispania', NULL, NULL, '05'),
('05360', 'Itagui', NULL, NULL, '05'),
('05361', 'Ituan', NULL, NULL, '05'),
('05364', 'Jardín', NULL, NULL, '05'),
('05368', 'Jericó', NULL, NULL, '05'),
('05376', 'La ceja', NULL, NULL, '05'),
('05380', 'La estrella', NULL, NULL, '05'),
('05390', 'La pintada', NULL, NULL, '05'),
('05400', 'La unión', NULL, NULL, '05'),
('05411', 'Liborina', NULL, NULL, '05'),
('05425', 'Maceo', NULL, NULL, '05'),
('05440', 'Marinilla', NULL, NULL, '05'),
('05467', 'Montebello', NULL, NULL, '05'),
('05475', 'Murindó', NULL, NULL, '05'),
('05480', 'Mutatá', NULL, NULL, '05'),
('05483', 'Nariño', NULL, NULL, '05'),
('05490', 'Necoclí', NULL, NULL, '05'),
('05495', 'Nechí', NULL, NULL, '05'),
('05501', 'Olaya', NULL, NULL, '05'),
('05541', 'Peñol', NULL, NULL, '05'),
('05543', 'Peque', NULL, NULL, '05'),
('05576', 'Pueblorrico', NULL, NULL, '05'),
('05579', 'Puerto berrío', NULL, NULL, '05'),
('05585', 'Puerto nare', NULL, NULL, '05'),
('05591', 'Puerto triunfo', NULL, NULL, '05'),
('05604', 'Remedios', NULL, NULL, '05'),
('05607', 'Retiro', NULL, NULL, '05'),
('05615', 'Rionegro', NULL, NULL, '05'),
('05628', 'Sabanalarga', NULL, NULL, '05'),
('05631', 'Sabaneta', NULL, NULL, '05'),
('05642', 'Salgar', NULL, NULL, '05'),
('05647', 'San andrés', NULL, NULL, '05'),
('05649', 'San carlos', NULL, NULL, '05'),
('05652', 'San francisco', NULL, NULL, '05'),
('05656', 'San jerónimo', NULL, NULL, '05'),
('05658', 'San josé de la montaña', NULL, NULL, '05'),
('05659', 'San juan de urabá', NULL, NULL, '05'),
('05660', 'San luis', NULL, NULL, '05'),
('05664', 'San pedro', NULL, NULL, '05'),
('05665', 'San pedro de uraba', NULL, NULL, '05'),
('05667', 'San rafael', NULL, NULL, '05'),
('05670', 'San roque', NULL, NULL, '05'),
('05674', 'San vicente', NULL, NULL, '05'),
('05679', 'Santa bárbara', NULL, NULL, '05'),
('05686', 'Santa rosa de osos', NULL, NULL, '05'),
('05690', 'Santo domin', NULL, NULL, '05'),
('05697', 'El santuario', NULL, NULL, '05'),
('05736', 'Sevia', NULL, NULL, '05'),
('05756', 'Sonson', NULL, NULL, '05'),
('05761', 'Sopetrán', NULL, NULL, '05'),
('05789', 'Támesis', NULL, NULL, '05'),
('05790', 'Tarazá', NULL, NULL, '05'),
('05792', 'Tarso', NULL, NULL, '05'),
('05809', 'Titiribí', NULL, NULL, '05'),
('05819', 'Toledo', NULL, NULL, '05'),
('05837', 'Turbo', NULL, NULL, '05'),
('05842', 'Uramita', NULL, NULL, '05'),
('05847', 'Urrao', NULL, NULL, '05'),
('05854', 'Valdivia', NULL, NULL, '05'),
('05856', 'Valparaíso', NULL, NULL, '05'),
('05858', 'Vegachí', NULL, NULL, '05'),
('05861', 'Venecia', NULL, NULL, '05'),
('05873', 'Vigía del fuerte', NULL, NULL, '05'),
('05885', 'Yalí', NULL, NULL, '05'),
('05887', 'Yarumal', NULL, NULL, '05'),
('05890', 'Yolombó', NULL, NULL, '05'),
('05893', 'Yondó', NULL, NULL, '05'),
('05895', 'Zaraza', NULL, NULL, '05'),
('08001', 'Barranquilla', NULL, NULL, '08'),
('08078', 'Baranoa', NULL, NULL, '08'),
('08137', 'Campo de la cruz', NULL, NULL, '08'),
('08141', 'Candelaria', NULL, NULL, '08'),
('08296', 'Galapa', NULL, NULL, '08'),
('08372', 'Juan de acosta', NULL, NULL, '08'),
('08421', 'Luruaco', NULL, NULL, '08'),
('08433', 'Malambo', NULL, NULL, '08'),
('08436', 'Manatí', NULL, NULL, '08'),
('08520', 'Palmar de varela', NULL, NULL, '08'),
('08549', 'Piojó', NULL, NULL, '08'),
('08558', 'Polonuevo', NULL, NULL, '08'),
('08560', 'Ponedera', NULL, NULL, '08'),
('08573', 'Puerto colombia', NULL, NULL, '08'),
('08606', 'Repelón', NULL, NULL, '08'),
('08634', 'Sabanagrande', NULL, NULL, '08'),
('08638', 'Sabanalarga', NULL, NULL, '08'),
('08675', 'Santa lucía', NULL, NULL, '08'),
('08685', 'Santo tomás', NULL, NULL, '08'),
('08758', 'Soledad', NULL, NULL, '08'),
('08770', 'Suan', NULL, NULL, '08'),
('08832', 'Tubará', NULL, NULL, '08'),
('08849', 'Usiacurí', NULL, NULL, '08'),
('11001', 'Botá', NULL, NULL, '11'),
('13001', 'CARTAGENA DE INDIAS', NULL, NULL, '13'),
('13006', 'Achí', NULL, NULL, '13'),
('13030', 'Altos del rosario', NULL, NULL, '13'),
('13042', 'Arenal', NULL, NULL, '13'),
('13052', 'Arjona', NULL, NULL, '13'),
('13062', 'Arroyohondo', NULL, NULL, '13'),
('13074', 'Barranco de loba', NULL, NULL, '13'),
('13140', 'Calamar', NULL, NULL, '13'),
('13160', 'Cantagallo', NULL, NULL, '13'),
('13188', 'Cicuco', NULL, NULL, '13'),
('13212', 'Córdoba', NULL, NULL, '13'),
('13222', 'Clemencia', NULL, NULL, '13'),
('13244', 'El carmen de bolívar', NULL, NULL, '13'),
('13248', 'El guamo', NULL, NULL, '13'),
('13268', 'El peñón', NULL, NULL, '13'),
('13300', 'Hatillo de loba', NULL, NULL, '13'),
('13430', 'Magangué', NULL, NULL, '13'),
('13433', 'Mahates', NULL, NULL, '13'),
('13440', 'Margarita', NULL, NULL, '13'),
('13442', 'María la baja', NULL, NULL, '13'),
('13458', 'Montecristo', NULL, NULL, '13'),
('13468', 'Mompós', NULL, NULL, '13'),
('13473', 'Morales', NULL, NULL, '13'),
('13549', 'Pinillos', NULL, NULL, '13'),
('13580', 'Regidor', NULL, NULL, '13'),
('13600', 'Río viejo', NULL, NULL, '13'),
('13620', 'San cristóbal', NULL, NULL, '13'),
('13647', 'San estanislao', NULL, NULL, '13'),
('13650', 'San fernando', NULL, NULL, '13'),
('13654', 'San jacinto', NULL, NULL, '13'),
('13655', 'San jacinto del cauca', NULL, NULL, '13'),
('13657', 'San juan nepomuceno', NULL, NULL, '13'),
('13667', 'San martín de loba', NULL, NULL, '13'),
('13670', 'San pablo', NULL, NULL, '13'),
('13673', 'Santa catalina', NULL, NULL, '13'),
('13683', 'Santa rosa', NULL, NULL, '13'),
('13688', 'Santa rosa del sur', NULL, NULL, '13'),
('13744', 'Simití', NULL, NULL, '13'),
('13760', 'Soplaviento', NULL, NULL, '13'),
('13780', 'Talaigua nuevo', NULL, NULL, '13'),
('13810', 'Tiquisio', NULL, NULL, '13'),
('13836', 'Turbaco', NULL, NULL, '13'),
('13838', 'Turbaná', NULL, NULL, '13'),
('13873', 'Villanueva', NULL, NULL, '13'),
('13894', 'Zambrano', NULL, NULL, '13'),
('15001', 'Tunja', NULL, NULL, '15'),
('15022', 'Almeida', NULL, NULL, '15'),
('15047', 'Aquitania', NULL, NULL, '15'),
('15051', 'Arcabuco', NULL, NULL, '15'),
('15087', 'Belén', NULL, NULL, '15'),
('15090', 'Berbeo', NULL, NULL, '15'),
('15092', 'Betéitiva', NULL, NULL, '15'),
('15097', 'Boavita', NULL, NULL, '15'),
('15104', 'Boyacá', NULL, NULL, '15'),
('15106', 'Briceño', NULL, NULL, '15'),
('15109', 'Buenavista', NULL, NULL, '15'),
('15114', 'Busbanzá', NULL, NULL, '15'),
('15131', 'Caldas', NULL, NULL, '15'),
('15135', 'Campohermoso', NULL, NULL, '15'),
('15162', 'Cerinza', NULL, NULL, '15'),
('15172', 'Chinavita', NULL, NULL, '15'),
('15176', 'Chiquinquirá', NULL, NULL, '15'),
('15180', 'Chiscas', NULL, NULL, '15'),
('15183', 'Chita', NULL, NULL, '15'),
('15185', 'Chitaraque', NULL, NULL, '15'),
('15187', 'Chivatá', NULL, NULL, '15'),
('15189', 'Ciénega', NULL, NULL, '15'),
('15204', 'Cómbita', NULL, NULL, '15'),
('15212', 'Coper', NULL, NULL, '15'),
('15215', 'Corrales', NULL, NULL, '15'),
('15218', 'Covarachía', NULL, NULL, '15'),
('15223', 'Cubará', NULL, NULL, '15'),
('15224', 'Cucaita', NULL, NULL, '15'),
('15226', 'Cuítiva', NULL, NULL, '15'),
('15232', 'Chíquiza', NULL, NULL, '15'),
('15236', 'Chivor', NULL, NULL, '15'),
('15238', 'Duitama', NULL, NULL, '15'),
('15244', 'El cocuy', NULL, NULL, '15'),
('15248', 'El espino', NULL, NULL, '15'),
('15272', 'Firavitoba', NULL, NULL, '15'),
('15276', 'Floresta', NULL, NULL, '15'),
('15293', 'Gachantivá', NULL, NULL, '15'),
('15296', 'Gameza', NULL, NULL, '15'),
('15299', 'Garaa', NULL, NULL, '15'),
('15317', 'Guacamayas', NULL, NULL, '15'),
('15322', 'Guateque', NULL, NULL, '15'),
('15325', 'Guayatá', NULL, NULL, '15'),
('15332', 'Güicán', NULL, NULL, '15'),
('15362', 'Iza', NULL, NULL, '15'),
('15367', 'Jenesano', NULL, NULL, '15'),
('15368', 'Jericó', NULL, NULL, '15'),
('15377', 'Labranzagrande', NULL, NULL, '15'),
('15380', 'La capilla', NULL, NULL, '15'),
('15401', 'La victoria', NULL, NULL, '15'),
('15403', 'La uvita', NULL, NULL, '15'),
('15407', 'Villa de leyva', NULL, NULL, '15'),
('15425', 'Macanal', NULL, NULL, '15'),
('15442', 'Maripí', NULL, NULL, '15'),
('15455', 'Miraflores', NULL, NULL, '15'),
('15464', 'Mongua', NULL, NULL, '15'),
('15466', 'Monguí', NULL, NULL, '15'),
('15469', 'Moniquirá', NULL, NULL, '15'),
('15476', 'Motavita', NULL, NULL, '15'),
('15480', 'Muzo', NULL, NULL, '15'),
('15491', 'Nobsa', NULL, NULL, '15'),
('15494', 'Nuevo colón', NULL, NULL, '15'),
('15500', 'Oicatá', NULL, NULL, '15'),
('15507', 'Otanche', NULL, NULL, '15'),
('15511', 'Pachavita', NULL, NULL, '15'),
('15514', 'Páez', NULL, NULL, '15'),
('15516', 'Paipa', NULL, NULL, '15'),
('15518', 'Pajarito', NULL, NULL, '15'),
('15522', 'Panqueba', NULL, NULL, '15'),
('15531', 'Pauna', NULL, NULL, '15'),
('15533', 'Paya', NULL, NULL, '15'),
('15537', 'Paz de río', NULL, NULL, '15'),
('15542', 'Pesca', NULL, NULL, '15'),
('15550', 'Pisba', NULL, NULL, '15'),
('15572', 'Puerto boyacá', NULL, NULL, '15'),
('15580', 'Quípama', NULL, NULL, '15'),
('15599', 'Ramiriquí', NULL, NULL, '15'),
('15600', 'Ráquira', NULL, NULL, '15'),
('15621', 'Rondón', NULL, NULL, '15'),
('15632', 'Saboyá', NULL, NULL, '15'),
('15638', 'Sáchica', NULL, NULL, '15'),
('15646', 'Samacá', NULL, NULL, '15'),
('15660', 'San eduardo', NULL, NULL, '15'),
('15664', 'San josé de pare', NULL, NULL, '15'),
('15667', 'San luis de gaceno', NULL, NULL, '15'),
('15673', 'San mateo', NULL, NULL, '15'),
('15676', 'San miguel de sema', NULL, NULL, '15'),
('15681', 'San pablo de borbur', NULL, NULL, '15'),
('15686', 'Santana', NULL, NULL, '15'),
('15690', 'Santa maría', NULL, NULL, '15'),
('15693', 'Santa rosa de viterbo', NULL, NULL, '15'),
('15696', 'Santa sofía', NULL, NULL, '15'),
('15720', 'Sativanorte', NULL, NULL, '15'),
('15723', 'Sativasur', NULL, NULL, '15'),
('15740', 'Siachoque', NULL, NULL, '15'),
('15753', 'Soatá', NULL, NULL, '15'),
('15755', 'Socotá', NULL, NULL, '15'),
('15757', 'Socha', NULL, NULL, '15'),
('15759', 'Sogamoso', NULL, NULL, '15'),
('15761', 'Somondoco', NULL, NULL, '15'),
('15762', 'Sora', NULL, NULL, '15'),
('15763', 'Sotaquirá', NULL, NULL, '15'),
('15764', 'Soracá', NULL, NULL, '15'),
('15774', 'Susacón', NULL, NULL, '15'),
('15776', 'Sutamarchán', NULL, NULL, '15'),
('15778', 'Sutatenza', NULL, NULL, '15'),
('15790', 'Tasco', NULL, NULL, '15'),
('15798', 'Tenza', NULL, NULL, '15'),
('15804', 'Tibaná', NULL, NULL, '15'),
('15806', 'Tibasosa', NULL, NULL, '15'),
('15808', 'Tinjacá', NULL, NULL, '15'),
('15810', 'Tipacoque', NULL, NULL, '15'),
('15814', 'Toca', NULL, NULL, '15'),
('15816', 'Togüí', NULL, NULL, '15'),
('15820', 'Tópaga', NULL, NULL, '15'),
('15822', 'Tota', NULL, NULL, '15'),
('15832', 'Tununguá', NULL, NULL, '15'),
('15835', 'Turmequé', NULL, NULL, '15'),
('15837', 'Tuta', NULL, NULL, '15'),
('15839', 'Tutazá', NULL, NULL, '15'),
('15842', 'Umbita', NULL, NULL, '15'),
('15861', 'Ventaquemada', NULL, NULL, '15'),
('15879', 'Viracachá', NULL, NULL, '15'),
('15897', 'Zetaquira', NULL, NULL, '15'),
('17001', 'Manizales', NULL, NULL, '17'),
('17013', 'Aguadas', NULL, NULL, '17'),
('17042', 'Anserma', NULL, NULL, '17'),
('17050', 'Aranzazu', NULL, NULL, '17'),
('17088', 'Belalcázar', NULL, NULL, '17'),
('17174', 'Chinchiná', NULL, NULL, '17'),
('17272', 'Filadelfia', NULL, NULL, '17'),
('17380', 'La dorada', NULL, NULL, '17'),
('17388', 'La merced', NULL, NULL, '17'),
('17433', 'Manzanares', NULL, NULL, '17'),
('17442', 'Marmato', NULL, NULL, '17'),
('17444', 'Marquetalia', NULL, NULL, '17'),
('17446', 'Marulanda', NULL, NULL, '17'),
('17486', 'Neira', NULL, NULL, '17'),
('17495', 'Norcasia', NULL, NULL, '17'),
('17513', 'Pácora', NULL, NULL, '17'),
('17524', 'Palestina', NULL, NULL, '17'),
('17541', 'Pensilvania', NULL, NULL, '17'),
('17614', 'Riosucio', NULL, NULL, '17'),
('17616', 'Risaralda', NULL, NULL, '17'),
('17653', 'Salamina', NULL, NULL, '17'),
('17662', 'Samaná', NULL, NULL, '17'),
('17665', 'San josé', NULL, NULL, '17'),
('17777', 'Supía', NULL, NULL, '17'),
('17867', 'Victoria', NULL, NULL, '17'),
('17873', 'Villamaría', NULL, NULL, '17'),
('17877', 'Viterbo', NULL, NULL, '17'),
('18001', 'Florencia', NULL, NULL, '18'),
('18029', 'Albania', NULL, NULL, '18'),
('18094', 'Belén de los andaquies', NULL, NULL, '18'),
('18150', 'Cartagena del chairá', NULL, NULL, '18'),
('18205', 'Curillo', NULL, NULL, '18'),
('18247', 'El doncello', NULL, NULL, '18'),
('18256', 'El paujil', NULL, NULL, '18'),
('18410', 'La montañita', NULL, NULL, '18'),
('18460', 'Milán', NULL, NULL, '18'),
('18479', 'Morelia', NULL, NULL, '18'),
('18592', 'Puerto rico', NULL, NULL, '18'),
('18610', 'San josé del fragua', NULL, NULL, '18'),
('18753', 'San vicente del caguán', NULL, NULL, '18'),
('18756', 'Solano', NULL, NULL, '18'),
('18785', 'Solita', NULL, NULL, '18'),
('18860', 'Valparaíso', NULL, NULL, '18'),
('19001', 'Popayán', NULL, NULL, '19'),
('19022', 'Almaguer', NULL, NULL, '19'),
('19050', 'Argelia', NULL, NULL, '19'),
('19075', 'Balboa', NULL, NULL, '19'),
('19100', 'Bolívar', NULL, NULL, '19'),
('19110', 'Buenos aires', NULL, NULL, '19'),
('19130', 'Cajibío', NULL, NULL, '19'),
('19137', 'Caldono', NULL, NULL, '19'),
('19142', 'Caloto', NULL, NULL, '19'),
('19212', 'Corinto', NULL, NULL, '19'),
('19256', 'El tambo', NULL, NULL, '19'),
('19290', 'Florencia', NULL, NULL, '19'),
('19318', 'Guapi', NULL, NULL, '19'),
('19355', 'Inzá', NULL, NULL, '19'),
('19364', 'Jambaló', NULL, NULL, '19'),
('19392', 'La sierra', NULL, NULL, '19'),
('19397', 'La vega', NULL, NULL, '19'),
('19418', 'López', NULL, NULL, '19'),
('19450', 'Mercaderes', NULL, NULL, '19'),
('19455', 'Miranda', NULL, NULL, '19'),
('19473', 'Morales', NULL, NULL, '19'),
('19513', 'Padilla', NULL, NULL, '19'),
('19517', 'Paez', NULL, NULL, '19'),
('19532', 'Patía', NULL, NULL, '19'),
('19533', 'Piamonte', NULL, NULL, '19'),
('19548', 'Piendamó', NULL, NULL, '19'),
('19573', 'Puerto tejada', NULL, NULL, '19'),
('19585', 'Puracé', NULL, NULL, '19'),
('19622', 'Rosas', NULL, NULL, '19'),
('19693', 'San sebastián', NULL, NULL, '19'),
('19698', 'Santander de quilichao', NULL, NULL, '19'),
('19701', 'Santa rosa', NULL, NULL, '19'),
('19743', 'Silvia', NULL, NULL, '19'),
('19760', 'Sotara', NULL, NULL, '19'),
('19780', 'Suárez', NULL, NULL, '19'),
('19785', 'Sucre', NULL, NULL, '19'),
('19807', 'Timbío', NULL, NULL, '19'),
('19809', 'Timbiquí', NULL, NULL, '19'),
('19821', 'Toribio', NULL, NULL, '19'),
('19824', 'Totoró', NULL, NULL, '19'),
('19845', 'Villa rica', NULL, NULL, '19'),
('20001', 'Valledupar', NULL, NULL, '20'),
('20011', 'Aguachica', NULL, NULL, '20'),
('20013', 'Agustín codazzi', NULL, NULL, '20'),
('20032', 'Astrea', NULL, NULL, '20'),
('20045', 'Becerril', NULL, NULL, '20'),
('20060', 'Bosconia', NULL, NULL, '20'),
('20175', 'Chimichagua', NULL, NULL, '20'),
('20178', 'Chiriguaná', NULL, NULL, '20'),
('20228', 'Curumaní', NULL, NULL, '20'),
('20238', 'El copey', NULL, NULL, '20'),
('20250', 'El paso', NULL, NULL, '20'),
('20295', 'Gamarra', NULL, NULL, '20'),
('20310', 'nzález', NULL, NULL, '20'),
('20383', 'La gloria', NULL, NULL, '20'),
('20400', 'La jagua de ibirico', NULL, NULL, '20'),
('20443', 'Manaure', NULL, NULL, '20'),
('20517', 'Pailitas', NULL, NULL, '20'),
('20550', 'Pelaya', NULL, NULL, '20'),
('20570', 'Pueblo bello', NULL, NULL, '20'),
('20614', 'Río de oro', NULL, NULL, '20'),
('20621', 'La paz', NULL, NULL, '20'),
('20710', 'San alberto', NULL, NULL, '20'),
('20750', 'San die', NULL, NULL, '20'),
('20770', 'San martín', NULL, NULL, '20'),
('20787', 'Tamalameque', NULL, NULL, '20'),
('23001', 'Montería', NULL, NULL, '23'),
('23068', 'Ayapel', NULL, NULL, '23'),
('23079', 'Buenavista', NULL, NULL, '23'),
('23090', 'Canalete', NULL, NULL, '23'),
('23162', 'Cereté', NULL, NULL, '23'),
('23168', 'Chimá', NULL, NULL, '23'),
('23182', 'Chinú', NULL, NULL, '23'),
('23189', 'Ciénaga de oro', NULL, NULL, '23'),
('23300', 'Cotorra', NULL, NULL, '23'),
('23350', 'La apartada', NULL, NULL, '23'),
('23417', 'Lorica', NULL, NULL, '23'),
('23419', 'Los córdobas', NULL, NULL, '23'),
('23464', 'Momil', NULL, NULL, '23'),
('23466', 'Montelíbano', NULL, NULL, '23'),
('23500', 'Moñitos', NULL, NULL, '23'),
('23555', 'Planeta rica', NULL, NULL, '23'),
('23570', 'Pueblo nuevo', NULL, NULL, '23'),
('23574', 'Puerto escondido', NULL, NULL, '23'),
('23580', 'Puerto libertador', NULL, NULL, '23'),
('23586', 'Purísima', NULL, NULL, '23'),
('23660', 'Sahagún', NULL, NULL, '23'),
('23670', 'San andrés sotavento', NULL, NULL, '23'),
('23672', 'San antero', NULL, NULL, '23'),
('23675', 'San bernardo del viento', NULL, NULL, '23'),
('23678', 'San carlos', NULL, NULL, '23'),
('23686', 'San pelayo', NULL, NULL, '23'),
('23807', 'Tierralta', NULL, NULL, '23'),
('23855', 'Valencia', NULL, NULL, '23'),
('25001', 'Agua de dios', NULL, NULL, '25'),
('25019', 'Albán', NULL, NULL, '25'),
('25035', 'Anapoima', NULL, NULL, '25'),
('25040', 'Anolaima', NULL, NULL, '25'),
('25053', 'Arbeláez', NULL, NULL, '25'),
('25086', 'Beltrán', NULL, NULL, '25'),
('25095', 'Bituima', NULL, NULL, '25'),
('25099', 'Bojacá', NULL, NULL, '25'),
('25120', 'Cabrera', NULL, NULL, '25'),
('25123', 'Cachipay', NULL, NULL, '25'),
('25126', 'Cajicá', NULL, NULL, '25'),
('25148', 'Caparrapí', NULL, NULL, '25'),
('25151', 'Caqueza', NULL, NULL, '25'),
('25154', 'Carmen de carupa', NULL, NULL, '25'),
('25168', 'Chaguaní', NULL, NULL, '25'),
('25175', 'Chía', NULL, NULL, '25'),
('25178', 'Chipaque', NULL, NULL, '25'),
('25181', 'Choachí', NULL, NULL, '25'),
('25183', 'Chocontá', NULL, NULL, '25'),
('25200', 'Cogua', NULL, NULL, '25'),
('25214', 'Cota', NULL, NULL, '25'),
('25224', 'Cucunubá', NULL, NULL, '25'),
('25245', 'El colegio', NULL, NULL, '25'),
('25258', 'El peñón', NULL, NULL, '25'),
('25260', 'El rosal', NULL, NULL, '25'),
('25269', 'Facatativá', NULL, NULL, '25'),
('25279', 'Fomeque', NULL, NULL, '25'),
('25281', 'Fosca', NULL, NULL, '25'),
('25286', 'Funza', NULL, NULL, '25'),
('25288', 'Fúquene', NULL, NULL, '25'),
('25290', 'Fusagasugá', NULL, NULL, '25'),
('25293', 'Gachala', NULL, NULL, '25'),
('25295', 'Gachancipá', NULL, NULL, '25'),
('25297', 'Gachetá', NULL, NULL, '25'),
('25299', 'Gama', NULL, NULL, '25'),
('25307', 'Girardot', NULL, NULL, '25'),
('25312', 'Granada', NULL, NULL, '25'),
('25317', 'Guachetá', NULL, NULL, '25'),
('25320', 'Guaduas', NULL, NULL, '25'),
('25322', 'Guasca', NULL, NULL, '25'),
('25324', 'Guataquí', NULL, NULL, '25'),
('25326', 'Guatavita', NULL, NULL, '25'),
('25328', 'Guayabal de siquima', NULL, NULL, '25'),
('25335', 'Guayabetal', NULL, NULL, '25'),
('25339', 'Gutiérrez', NULL, NULL, '25'),
('25368', 'Jerusalén', NULL, NULL, '25'),
('25372', 'Junín', NULL, NULL, '25'),
('25377', 'La calera', NULL, NULL, '25'),
('25386', 'La mesa', NULL, NULL, '25'),
('25394', 'La palma', NULL, NULL, '25'),
('25398', 'La peña', NULL, NULL, '25'),
('25402', 'La vega', NULL, NULL, '25'),
('25407', 'Lenguazaque', NULL, NULL, '25'),
('25426', 'Macheta', NULL, NULL, '25'),
('25430', 'Madrid', NULL, NULL, '25'),
('25436', 'Manta', NULL, NULL, '25'),
('25438', 'Medina', NULL, NULL, '25'),
('25473', 'Mosquera', NULL, NULL, '25'),
('25483', 'Nariño', NULL, NULL, '25'),
('25486', 'Nemocón', NULL, NULL, '25'),
('25488', 'Nilo', NULL, NULL, '25'),
('25489', 'Nimaima', NULL, NULL, '25'),
('25491', 'Nocaima', NULL, NULL, '25'),
('25506', 'Venecia', NULL, NULL, '25'),
('25513', 'Pacho', NULL, NULL, '25'),
('25518', 'Paime', NULL, NULL, '25'),
('25524', 'Pandi', NULL, NULL, '25'),
('25530', 'Paratebueno', NULL, NULL, '25'),
('25535', 'Pasca', NULL, NULL, '25'),
('25572', 'Puerto salgar', NULL, NULL, '25'),
('25580', 'Pulí', NULL, NULL, '25'),
('25592', 'Quebradanegra', NULL, NULL, '25'),
('25594', 'Quetame', NULL, NULL, '25'),
('25596', 'Quipile', NULL, NULL, '25'),
('25599', 'Apulo', NULL, NULL, '25'),
('25612', 'Ricaurte', NULL, NULL, '25'),
('25645', 'San antonio del tequendama', NULL, NULL, '25'),
('25649', 'San bernardo', NULL, NULL, '25'),
('25653', 'San cayetano', NULL, NULL, '25'),
('25658', 'San francisco', NULL, NULL, '25'),
('25662', 'San juan de río seco', NULL, NULL, '25'),
('25718', 'Sasaima', NULL, NULL, '25'),
('25736', 'Sesquilé', NULL, NULL, '25'),
('25740', 'Sibaté', NULL, NULL, '25'),
('25743', 'Silvania', NULL, NULL, '25'),
('25745', 'Simijaca', NULL, NULL, '25'),
('25754', 'Soacha', NULL, NULL, '25'),
('25758', 'Sopó', NULL, NULL, '25'),
('25769', 'Subachoque', NULL, NULL, '25'),
('25772', 'Suesca', NULL, NULL, '25'),
('25777', 'Supatá', NULL, NULL, '25'),
('25779', 'Susa', NULL, NULL, '25'),
('25781', 'Sutatausa', NULL, NULL, '25'),
('25785', 'Tabio', NULL, NULL, '25'),
('25793', 'Tausa', NULL, NULL, '25'),
('25797', 'Tena', NULL, NULL, '25'),
('25799', 'Tenjo', NULL, NULL, '25'),
('25805', 'Tibacuy', NULL, NULL, '25'),
('25807', 'Tibirita', NULL, NULL, '25'),
('25815', 'Tocaima', NULL, NULL, '25'),
('25817', 'Tocancipá', NULL, NULL, '25'),
('25823', 'Topaipí', NULL, NULL, '25'),
('25839', 'Ubalá', NULL, NULL, '25'),
('25841', 'Ubaque', NULL, NULL, '25'),
('25843', 'Villa de san die de ubate', NULL, NULL, '25'),
('25845', 'Une', NULL, NULL, '25'),
('25851', 'Útica', NULL, NULL, '25'),
('25862', 'Vergara', NULL, NULL, '25'),
('25867', 'Vianí', NULL, NULL, '25'),
('25871', 'Villagómez', NULL, NULL, '25'),
('25873', 'Villapinzón', NULL, NULL, '25'),
('25875', 'Villeta', NULL, NULL, '25'),
('25878', 'Viotá', NULL, NULL, '25'),
('25885', 'Yacopí', NULL, NULL, '25'),
('25898', 'Zipacón', NULL, NULL, '25'),
('25899', 'Zipaquirá', NULL, NULL, '25'),
('27001', 'Quibdó', NULL, NULL, '27'),
('27006', 'Acandí', NULL, NULL, '27'),
('27025', 'Alto baudo', NULL, NULL, '27'),
('27050', 'Atrato', NULL, NULL, '27'),
('27073', 'Bagadó', NULL, NULL, '27'),
('27075', 'Bahía solano', NULL, NULL, '27'),
('27077', 'Bajo baudó', NULL, NULL, '27'),
('27086', 'Belén de bajirá', NULL, NULL, '27'),
('27099', 'Bojaya', NULL, NULL, '27'),
('27135', 'El cantón del san pablo', NULL, NULL, '27'),
('27150', 'Carmen del darien', NULL, NULL, '27'),
('27160', 'Cértegui', NULL, NULL, '27'),
('27205', 'Condoto', NULL, NULL, '27'),
('27245', 'El carmen de atrato', NULL, NULL, '27'),
('27250', 'El litoral del san juan', NULL, NULL, '27'),
('27361', 'Istmina', NULL, NULL, '27'),
('27372', 'Juradó', NULL, NULL, '27'),
('27413', 'Lloró', NULL, NULL, '27'),
('27425', 'Medio atrato', NULL, NULL, '27'),
('27430', 'Medio baudó', NULL, NULL, '27'),
('27450', 'Medio san juan', NULL, NULL, '27'),
('27491', 'Nóvita', NULL, NULL, '27'),
('27495', 'Nuquí', NULL, NULL, '27'),
('27580', 'Río iro', NULL, NULL, '27'),
('27600', 'Río quito', NULL, NULL, '27'),
('27615', 'Riosucio', NULL, NULL, '27'),
('27660', 'San josé del palmar', NULL, NULL, '27'),
('27745', 'Sipí', NULL, NULL, '27'),
('27787', 'Tadó', NULL, NULL, '27'),
('27800', 'Unguía', NULL, NULL, '27'),
('27810', 'Unión panamericana', NULL, NULL, '27'),
('41001', 'Neiva', NULL, NULL, '41'),
('41006', 'Acevedo', NULL, NULL, '41'),
('41013', 'Agrado', NULL, NULL, '41'),
('41016', 'Aipe', NULL, NULL, '41'),
('41020', 'Algeciras', NULL, NULL, '41'),
('41026', 'Altamira', NULL, NULL, '41'),
('41078', 'Baraya', NULL, NULL, '41'),
('41132', 'Campoalegre', NULL, NULL, '41'),
('41206', 'Colombia', NULL, NULL, '41'),
('41244', 'Elías', NULL, NULL, '41'),
('41298', 'Garzón', NULL, NULL, '41'),
('41306', 'Gigante', NULL, NULL, '41'),
('41319', 'Guadalupe', NULL, NULL, '41'),
('41349', 'Hobo', NULL, NULL, '41'),
('41357', 'Iquira', NULL, NULL, '41'),
('41359', 'Isnos', NULL, NULL, '41'),
('41378', 'La argentina', NULL, NULL, '41'),
('41396', 'La plata', NULL, NULL, '41'),
('41483', 'Nátaga', NULL, NULL, '41'),
('41503', 'Oporapa', NULL, NULL, '41'),
('41518', 'Paicol', NULL, NULL, '41'),
('41524', 'Palermo', NULL, NULL, '41'),
('41530', 'Palestina', NULL, NULL, '41'),
('41548', 'Pital', NULL, NULL, '41'),
('41551', 'Pitalito', NULL, NULL, '41'),
('41615', 'Rivera', NULL, NULL, '41'),
('41660', 'Saladoblanco', NULL, NULL, '41'),
('41668', 'San agustín', NULL, NULL, '41'),
('41676', 'Santa maría', NULL, NULL, '41'),
('41770', 'Suaza', NULL, NULL, '41'),
('41791', 'Tarqui', NULL, NULL, '41'),
('41797', 'Tesalia', NULL, NULL, '41'),
('41799', 'Tello', NULL, NULL, '41'),
('41801', 'Teruel', NULL, NULL, '41'),
('41807', 'Timaná', NULL, NULL, '41'),
('41872', 'Villavieja', NULL, NULL, '41'),
('41885', 'Yaguará', NULL, NULL, '41'),
('44001', 'Riohacha', NULL, NULL, '44'),
('44035', 'Albania', NULL, NULL, '44'),
('44078', 'Barrancas', NULL, NULL, '44'),
('44090', 'Dibulla', NULL, NULL, '44'),
('44098', 'Distracción', NULL, NULL, '44'),
('44110', 'El molino', NULL, NULL, '44'),
('44279', 'Fonseca', NULL, NULL, '44'),
('44378', 'Hatonuevo', NULL, NULL, '44'),
('44420', 'La jagua del pilar', NULL, NULL, '44'),
('44430', 'Maicao', NULL, NULL, '44'),
('44560', 'Manaure', NULL, NULL, '44'),
('44650', 'San juan del cesar', NULL, NULL, '44'),
('44847', 'Uribia', NULL, NULL, '44'),
('44855', 'Urumita', NULL, NULL, '44'),
('44874', 'Villanueva', NULL, NULL, '44'),
('47001', 'Santa marta', NULL, NULL, '47'),
('47030', 'Algarrobo', NULL, NULL, '47'),
('47053', 'Aracataca', NULL, NULL, '47'),
('47058', 'Ariguaní', NULL, NULL, '47'),
('47161', 'Cerro san antonio', NULL, NULL, '47'),
('47170', 'Chibolo', NULL, NULL, '47'),
('47189', 'Ciénaga', NULL, NULL, '47'),
('47205', 'Concordia', NULL, NULL, '47'),
('47245', 'El banco', NULL, NULL, '47'),
('47258', 'El piñon', NULL, NULL, '47'),
('47268', 'El retén', NULL, NULL, '47'),
('47288', 'Fundación', NULL, NULL, '47'),
('47318', 'Guamal', NULL, NULL, '47'),
('47460', 'Nueva granada', NULL, NULL, '47'),
('47541', 'Pedraza', NULL, NULL, '47'),
('47545', 'Pijiño del carmen', NULL, NULL, '47'),
('47551', 'Pivijay', NULL, NULL, '47'),
('47555', 'Plato', NULL, NULL, '47'),
('47570', 'Puebloviejo', NULL, NULL, '47'),
('47605', 'Remolino', NULL, NULL, '47'),
('47660', 'Sabanas de san angel', NULL, NULL, '47'),
('47675', 'Salamina', NULL, NULL, '47'),
('47692', 'San sebastián de buenavista', NULL, NULL, '47'),
('47703', 'San zenón', NULL, NULL, '47'),
('47707', 'Santa ana', NULL, NULL, '47'),
('47720', 'Santa bárbara de pinto', NULL, NULL, '47'),
('47745', 'Sitionuevo', NULL, NULL, '47'),
('47798', 'Tenerife', NULL, NULL, '47'),
('47960', 'Zapayán', NULL, NULL, '47'),
('47980', 'Zona bananera', NULL, NULL, '47'),
('50001', 'Villavicencio', NULL, NULL, '50'),
('50006', 'Acacías', NULL, NULL, '50'),
('50110', 'Barranca de upía', NULL, NULL, '50'),
('50124', 'Cabuyaro', NULL, NULL, '50'),
('50150', 'Castilla la nueva', NULL, NULL, '50'),
('50223', 'Cubarral', NULL, NULL, '50'),
('50226', 'Cumaral', NULL, NULL, '50'),
('50245', 'El calvario', NULL, NULL, '50'),
('50251', 'El castillo', NULL, NULL, '50'),
('50270', 'El dorado', NULL, NULL, '50'),
('50287', 'Fuente de oro', NULL, NULL, '50'),
('50313', 'Granada', NULL, NULL, '50'),
('50318', 'Guamal', NULL, NULL, '50'),
('50325', 'Mapiripán', NULL, NULL, '50'),
('50330', 'Mesetas', NULL, NULL, '50'),
('50350', 'La macarena', NULL, NULL, '50'),
('50370', 'Uribe', NULL, NULL, '50'),
('50400', 'Lejanías', NULL, NULL, '50'),
('50450', 'Puerto concordia', NULL, NULL, '50'),
('50568', 'Puerto gaitán', NULL, NULL, '50'),
('50573', 'Puerto lópez', NULL, NULL, '50'),
('50577', 'Puerto lleras', NULL, NULL, '50'),
('50590', 'Puerto rico', NULL, NULL, '50'),
('50606', 'Restrepo', NULL, NULL, '50'),
('50680', 'San carlos de guaroa', NULL, NULL, '50'),
('50683', 'San juan de arama', NULL, NULL, '50'),
('50686', 'San juanito', NULL, NULL, '50'),
('50689', 'San martín', NULL, NULL, '50'),
('50711', 'Vistahermosa', NULL, NULL, '50'),
('52001', 'Pasto', NULL, NULL, '52'),
('52019', 'Albán', NULL, NULL, '52'),
('52022', 'Aldana', NULL, NULL, '52'),
('52036', 'Ancuyá', NULL, NULL, '52'),
('52051', 'Arboleda', NULL, NULL, '52'),
('52079', 'Barbacoas', NULL, NULL, '52'),
('52083', 'Belén', NULL, NULL, '52'),
('52110', 'Buesaco', NULL, NULL, '52'),
('52203', 'Colón', NULL, NULL, '52'),
('52207', 'Consaca', NULL, NULL, '52'),
('52210', 'Contadero', NULL, NULL, '52'),
('52215', 'Córdoba', NULL, NULL, '52'),
('52224', 'Cuaspud', NULL, NULL, '52'),
('52227', 'Cumbal', NULL, NULL, '52'),
('52233', 'Cumbitara', NULL, NULL, '52'),
('52240', 'Chachagüí', NULL, NULL, '52'),
('52250', 'El charco', NULL, NULL, '52'),
('52254', 'El peñol', NULL, NULL, '52'),
('52256', 'El rosario', NULL, NULL, '52'),
('52258', 'El tablón de gómez', NULL, NULL, '52'),
('52260', 'El tambo', NULL, NULL, '52'),
('52287', 'Funes', NULL, NULL, '52'),
('52317', 'Guachucal', NULL, NULL, '52'),
('52320', 'Guaitarilla', NULL, NULL, '52'),
('52323', 'Gualmatán', NULL, NULL, '52'),
('52352', 'Iles', NULL, NULL, '52'),
('52354', 'Imués', NULL, NULL, '52'),
('52356', 'Ipiales', NULL, NULL, '52'),
('52378', 'La cruz', NULL, NULL, '52'),
('52381', 'La florida', NULL, NULL, '52'),
('52385', 'La llanada', NULL, NULL, '52'),
('52390', 'La tola', NULL, NULL, '52'),
('52399', 'La unión', NULL, NULL, '52'),
('52405', 'Leiva', NULL, NULL, '52'),
('52411', 'Linares', NULL, NULL, '52'),
('52418', 'Los andes', NULL, NULL, '52'),
('52427', 'Magüi', NULL, NULL, '52'),
('52435', 'Mallama', NULL, NULL, '52'),
('52473', 'Mosquera', NULL, NULL, '52'),
('52480', 'Nariño', NULL, NULL, '52'),
('52490', 'Olaya herrera', NULL, NULL, '52'),
('52506', 'Ospina', NULL, NULL, '52'),
('52520', 'Francisco pizarro', NULL, NULL, '52'),
('52540', 'Policarpa', NULL, NULL, '52'),
('52560', 'Potosí', NULL, NULL, '52'),
('52565', 'Providencia', NULL, NULL, '52'),
('52573', 'Puerres', NULL, NULL, '52'),
('52585', 'Pupiales', NULL, NULL, '52'),
('52612', 'Ricaurte', NULL, NULL, '52'),
('52621', 'Roberto payán', NULL, NULL, '52'),
('52678', 'Samanie', NULL, NULL, '52'),
('52683', 'Sandoná', NULL, NULL, '52'),
('52685', 'San bernardo', NULL, NULL, '52'),
('52687', 'San lorenzo', NULL, NULL, '52'),
('52693', 'San pablo', NULL, NULL, '52'),
('52694', 'San pedro de carta', NULL, NULL, '52'),
('52696', 'Santa bárbara', NULL, NULL, '52'),
('52699', 'Santacruz', NULL, NULL, '52'),
('52720', 'Sapuyes', NULL, NULL, '52'),
('52786', 'Taminan', NULL, NULL, '52'),
('52788', 'Tangua', NULL, NULL, '52'),
('52835', 'Tumaco', NULL, NULL, '52'),
('52838', 'Túquerres', NULL, NULL, '52'),
('52885', 'Yacuanquer', NULL, NULL, '52'),
('54001', 'Cúcuta', NULL, NULL, '54'),
('54003', 'Abre', NULL, NULL, '54'),
('54051', 'Arboledas', NULL, NULL, '54'),
('54099', 'Bochalema', NULL, NULL, '54'),
('54109', 'Bucarasica', NULL, NULL, '54'),
('54125', 'Cácota', NULL, NULL, '54'),
('54128', 'Cachirá', NULL, NULL, '54'),
('54172', 'Chinácota', NULL, NULL, '54'),
('54174', 'Chitagá', NULL, NULL, '54'),
('54206', 'Convención', NULL, NULL, '54'),
('54223', 'Cucutilla', NULL, NULL, '54'),
('54239', 'Durania', NULL, NULL, '54'),
('54245', 'El carmen', NULL, NULL, '54'),
('54250', 'El tarra', NULL, NULL, '54'),
('54261', 'El zulia', NULL, NULL, '54'),
('54313', 'Gramalote', NULL, NULL, '54'),
('54344', 'Hacarí', NULL, NULL, '54'),
('54347', 'Herrán', NULL, NULL, '54'),
('54377', 'Labateca', NULL, NULL, '54'),
('54385', 'La esperanza', NULL, NULL, '54'),
('54398', 'La playa', NULL, NULL, '54'),
('54405', 'Los patios', NULL, NULL, '54'),
('54418', 'Lourdes', NULL, NULL, '54'),
('54480', 'Mutiscua', NULL, NULL, '54'),
('54498', 'Ocaña', NULL, NULL, '54'),
('54518', 'Pamplona', NULL, NULL, '54'),
('54520', 'Pamplonita', NULL, NULL, '54'),
('54553', 'Puerto santander', NULL, NULL, '54'),
('54599', 'Ranvalia', NULL, NULL, '54'),
('54660', 'Salazar', NULL, NULL, '54'),
('54670', 'San calixto', NULL, NULL, '54'),
('54673', 'San cayetano', NULL, NULL, '54'),
('54680', 'Santia', NULL, NULL, '54'),
('54720', 'Sardinata', NULL, NULL, '54'),
('54743', 'Silos', NULL, NULL, '54'),
('54800', 'Teorama', NULL, NULL, '54'),
('54810', 'Tibú', NULL, NULL, '54'),
('54820', 'Toledo', NULL, NULL, '54'),
('54871', 'Villa caro', NULL, NULL, '54'),
('54874', 'Villa del rosario', NULL, NULL, '54'),
('63001', 'Armenia', NULL, NULL, '63'),
('63111', 'Buenavista', NULL, NULL, '63'),
('63130', 'Calarca', NULL, NULL, '63'),
('63190', 'Circasia', NULL, NULL, '63'),
('63212', 'Córdoba', NULL, NULL, '63'),
('63272', 'Filandia', NULL, NULL, '63'),
('63302', 'Génova', NULL, NULL, '63'),
('63401', 'La tebaida', NULL, NULL, '63'),
('63470', 'Montenegro', NULL, NULL, '63'),
('63548', 'Pijao', NULL, NULL, '63'),
('63594', 'Quimbaya', NULL, NULL, '63'),
('63690', 'Salento', NULL, NULL, '63'),
('66001', 'Pereira', NULL, NULL, '66'),
('66045', 'Apía', NULL, NULL, '66'),
('66075', 'Balboa', NULL, NULL, '66'),
('66088', 'Belén de umbría', NULL, NULL, '66'),
('66170', 'Dosquebradas', NULL, NULL, '66'),
('66318', 'Guática', NULL, NULL, '66'),
('66383', 'La celia', NULL, NULL, '66'),
('66400', 'La virginia', NULL, NULL, '66'),
('66440', 'Marsella', NULL, NULL, '66'),
('66456', 'Mistrató', NULL, NULL, '66'),
('66572', 'Pueblo rico', NULL, NULL, '66'),
('66594', 'Quinchía', NULL, NULL, '66'),
('66682', 'Santa rosa de cabal', NULL, NULL, '66'),
('66687', 'Santuario', NULL, NULL, '66'),
('68001', 'Bucaramanga', NULL, NULL, '68'),
('68013', 'Aguada', NULL, NULL, '68'),
('68020', 'Albania', NULL, NULL, '68'),
('68051', 'Aratoca', NULL, NULL, '68'),
('68077', 'Barbosa', NULL, NULL, '68'),
('68079', 'Barichara', NULL, NULL, '68'),
('68081', 'Barrancabermeja', NULL, NULL, '68'),
('68092', 'Betulia', NULL, NULL, '68'),
('68101', 'Bolívar', NULL, NULL, '68'),
('68121', 'Cabrera', NULL, NULL, '68'),
('68132', 'California', NULL, NULL, '68'),
('68147', 'Capitanejo', NULL, NULL, '68'),
('68152', 'Carcasí', NULL, NULL, '68'),
('68160', 'Cepitá', NULL, NULL, '68'),
('68162', 'Cerrito', NULL, NULL, '68'),
('68167', 'Charalá', NULL, NULL, '68'),
('68169', 'Charta', NULL, NULL, '68'),
('68176', 'Chima', NULL, NULL, '68'),
('68179', 'Chipatá', NULL, NULL, '68'),
('68190', 'Cimitarra', NULL, NULL, '68'),
('68207', 'Concepción', NULL, NULL, '68'),
('68209', 'Confines', NULL, NULL, '68'),
('68211', 'Contratación', NULL, NULL, '68'),
('68217', 'Coromoro', NULL, NULL, '68'),
('68229', 'Curití', NULL, NULL, '68'),
('68235', 'El carmen de chucurí', NULL, NULL, '68'),
('68245', 'El guacamayo', NULL, NULL, '68'),
('68250', 'El peñón', NULL, NULL, '68'),
('68255', 'El playón', NULL, NULL, '68'),
('68264', 'Encino', NULL, NULL, '68'),
('68266', 'Enciso', NULL, NULL, '68'),
('68271', 'Florián', NULL, NULL, '68'),
('68276', 'Floridablanca', NULL, NULL, '68'),
('68296', 'Galán', NULL, NULL, '68'),
('68298', 'Gambita', NULL, NULL, '68'),
('68307', 'Girón', NULL, NULL, '68'),
('68318', 'Guaca', NULL, NULL, '68'),
('68320', 'Guadalupe', NULL, NULL, '68'),
('68322', 'Guapotá', NULL, NULL, '68'),
('68324', 'Guavatá', NULL, NULL, '68'),
('68327', 'Güepsa', NULL, NULL, '68'),
('68344', 'Hato', NULL, NULL, '68'),
('68368', 'Jesús maría', NULL, NULL, '68'),
('68370', 'Jordán', NULL, NULL, '68'),
('68377', 'La belleza', NULL, NULL, '68'),
('68385', 'Landázuri', NULL, NULL, '68'),
('68397', 'La paz', NULL, NULL, '68'),
('68406', 'Lebríja', NULL, NULL, '68'),
('68418', 'Los santos', NULL, NULL, '68'),
('68425', 'Macaravita', NULL, NULL, '68'),
('68432', 'Málaga', NULL, NULL, '68'),
('68444', 'Matanza', NULL, NULL, '68'),
('68464', 'Motes', NULL, NULL, '68'),
('68468', 'Molagavita', NULL, NULL, '68'),
('68498', 'Ocamonte', NULL, NULL, '68'),
('68500', 'Oiba', NULL, NULL, '68'),
('68502', 'Onzaga', NULL, NULL, '68'),
('68522', 'Palmar', NULL, NULL, '68'),
('68524', 'Palmas del socorro', NULL, NULL, '68'),
('68533', 'Páramo', NULL, NULL, '68'),
('68547', 'Piedecuesta', NULL, NULL, '68'),
('68549', 'Pinchote', NULL, NULL, '68'),
('68572', 'Puente nacional', NULL, NULL, '68'),
('68573', 'Puerto parra', NULL, NULL, '68'),
('68575', 'Puerto wilches', NULL, NULL, '68'),
('68615', 'Rionegro', NULL, NULL, '68'),
('68655', 'Sabana de torres', NULL, NULL, '68'),
('68669', 'San andrés', NULL, NULL, '68'),
('68673', 'San benito', NULL, NULL, '68'),
('68679', 'San gil', NULL, NULL, '68'),
('68682', 'San joaquín', NULL, NULL, '68'),
('68684', 'San josé de miranda', NULL, NULL, '68'),
('68686', 'San miguel', NULL, NULL, '68'),
('68689', 'San vicente de chucurí', NULL, NULL, '68'),
('68705', 'Santa bárbara', NULL, NULL, '68'),
('68720', 'Santa helena del opón', NULL, NULL, '68'),
('68745', 'Simacota', NULL, NULL, '68'),
('68755', 'Socorro', NULL, NULL, '68'),
('68770', 'Suaita', NULL, NULL, '68'),
('68773', 'Sucre', NULL, NULL, '68'),
('68780', 'Suratá', NULL, NULL, '68'),
('68820', 'Tona', NULL, NULL, '68'),
('68855', 'Valle de san josé', NULL, NULL, '68'),
('68861', 'Vélez', NULL, NULL, '68'),
('68867', 'Vetas', NULL, NULL, '68'),
('68872', 'Villanueva', NULL, NULL, '68'),
('68895', 'Zapatoca', NULL, NULL, '68'),
('70001', 'Sincelejo', NULL, NULL, '70'),
('70110', 'Buenavista', NULL, NULL, '70'),
('70124', 'Caimito', NULL, NULL, '70'),
('70204', 'Coloso', NULL, NULL, '70'),
('70215', 'Corozal', NULL, NULL, '70'),
('70221', 'Coveñas', NULL, NULL, '70'),
('70230', 'Chalán', NULL, NULL, '70'),
('70233', 'El roble', NULL, NULL, '70'),
('70235', 'Galeras', NULL, NULL, '70'),
('70265', 'Guaranda', NULL, NULL, '70'),
('70400', 'La unión', NULL, NULL, '70'),
('70418', 'Los palmitos', NULL, NULL, '70'),
('70429', 'Majagual', NULL, NULL, '70'),
('70473', 'Morroa', NULL, NULL, '70'),
('70508', 'Ovejas', NULL, NULL, '70'),
('70523', 'Palmito', NULL, NULL, '70'),
('70670', 'Sampués', NULL, NULL, '70'),
('70678', 'San benito abad', NULL, NULL, '70'),
('70702', 'San juan de betulia', NULL, NULL, '70'),
('70708', 'San marcos', NULL, NULL, '70'),
('70713', 'San onofre', NULL, NULL, '70'),
('70717', 'San pedro', NULL, NULL, '70'),
('70742', 'Sincé', NULL, NULL, '70'),
('70771', 'Sucre', NULL, NULL, '70'),
('70820', 'Santia de tolú', NULL, NULL, '70'),
('70823', 'Tolú viejo', NULL, NULL, '70'),
('73001', 'Ibagué', NULL, NULL, '73'),
('73024', 'Alpujarra', NULL, NULL, '73'),
('73026', 'Alvarado', NULL, NULL, '73'),
('73030', 'Ambalema', NULL, NULL, '73'),
('73043', 'Anzoátegui', NULL, NULL, '73'),
('73055', 'Armero', NULL, NULL, '73'),
('73067', 'Ataco', NULL, NULL, '73'),
('73124', 'Cajamarca', NULL, NULL, '73'),
('73148', 'Carmen de apicalá', NULL, NULL, '73'),
('73152', 'Casabianca', NULL, NULL, '73'),
('73168', 'Chaparral', NULL, NULL, '73'),
('73200', 'Coello', NULL, NULL, '73'),
('73217', 'Coyaima', NULL, NULL, '73'),
('73226', 'Cunday', NULL, NULL, '73'),
('73236', 'Dolores', NULL, NULL, '73'),
('73268', 'Espinal', NULL, NULL, '73'),
('73270', 'Falan', NULL, NULL, '73'),
('73275', 'Flandes', NULL, NULL, '73'),
('73283', 'Fresno', NULL, NULL, '73'),
('73319', 'Guamo', NULL, NULL, '73'),
('73347', 'Herveo', NULL, NULL, '73'),
('73349', 'Honda', NULL, NULL, '73'),
('73352', 'Icononzo', NULL, NULL, '73'),
('73408', 'Lérida', NULL, NULL, '73'),
('73411', 'Líbano', NULL, NULL, '73'),
('73443', 'Mariquita', NULL, NULL, '73'),
('73449', 'Melgar', NULL, NULL, '73'),
('73461', 'Murillo', NULL, NULL, '73'),
('73483', 'Natagaima', NULL, NULL, '73'),
('73504', 'Ortega', NULL, NULL, '73'),
('73520', 'Palocabildo', NULL, NULL, '73'),
('73547', 'Piedras', NULL, NULL, '73'),
('73555', 'Planadas', NULL, NULL, '73'),
('73563', 'Prado', NULL, NULL, '73'),
('73585', 'Purificación', NULL, NULL, '73'),
('73616', 'Rioblanco', NULL, NULL, '73'),
('73622', 'Roncesvalles', NULL, NULL, '73'),
('73624', 'Rovira', NULL, NULL, '73'),
('73671', 'Saldaña', NULL, NULL, '73'),
('73675', 'San antonio', NULL, NULL, '73'),
('73678', 'San luis', NULL, NULL, '73'),
('73686', 'Santa isabel', NULL, NULL, '73'),
('73770', 'Suárez', NULL, NULL, '73'),
('73854', 'Valle de san juan', NULL, NULL, '73'),
('73861', 'Venadillo', NULL, NULL, '73'),
('73870', 'Villahermosa', NULL, NULL, '73'),
('73873', 'Villarrica', NULL, NULL, '73'),
('76001', 'Cali', NULL, NULL, '76'),
('76020', 'Alcalá', NULL, NULL, '76'),
('76036', 'Andalucía', NULL, NULL, '76'),
('76041', 'Ansermanuevo', NULL, NULL, '76'),
('76054', 'Argelia', NULL, NULL, '76'),
('76100', 'Bolívar', NULL, NULL, '76'),
('76109', 'Buenaventura', NULL, NULL, '76'),
('76111', 'Guadalajara de buga', NULL, NULL, '76'),
('76113', 'Bugalagrande', NULL, NULL, '76'),
('76122', 'Caicedonia', NULL, NULL, '76'),
('76126', 'Calima', NULL, NULL, '76'),
('76130', 'Candelaria', NULL, NULL, '76'),
('76147', 'Carta', NULL, NULL, '76'),
('76233', 'Dagua', NULL, NULL, '76'),
('76243', 'El águila', NULL, NULL, '76'),
('76246', 'El cairo', NULL, NULL, '76'),
('76248', 'El cerrito', NULL, NULL, '76'),
('76250', 'El dovio', NULL, NULL, '76'),
('76275', 'Florida', NULL, NULL, '76'),
('76306', 'Ginebra', NULL, NULL, '76'),
('76318', 'Guacarí', NULL, NULL, '76'),
('76364', 'Jamundí', NULL, NULL, '76'),
('76377', 'La cumbre', NULL, NULL, '76'),
('76400', 'La unión', NULL, NULL, '76'),
('76403', 'La victoria', NULL, NULL, '76'),
('76497', 'Obando', NULL, NULL, '76'),
('76520', 'Palmira', NULL, NULL, '76'),
('76563', 'Pradera', NULL, NULL, '76'),
('76606', 'Restrepo', NULL, NULL, '76'),
('76616', 'Riofrío', NULL, NULL, '76'),
('76622', 'Roldanillo', NULL, NULL, '76'),
('76670', 'San pedro', NULL, NULL, '76'),
('76736', 'Sevilla', NULL, NULL, '76'),
('76823', 'Toro', NULL, NULL, '76'),
('76828', 'Trujillo', NULL, NULL, '76'),
('76834', 'Tuluá', NULL, NULL, '76'),
('76845', 'Ulloa', NULL, NULL, '76'),
('76863', 'Versalles', NULL, NULL, '76'),
('76869', 'Vijes', NULL, NULL, '76'),
('76890', 'Yotoco', NULL, NULL, '76'),
('76892', 'Yumbo', NULL, NULL, '76'),
('76895', 'Zarzal', NULL, NULL, '76'),
('81001', 'Arauca', NULL, NULL, '81'),
('81065', 'Arauquita', NULL, NULL, '81'),
('81220', 'Cravo norte', NULL, NULL, '81'),
('81300', 'Fortul', NULL, NULL, '81'),
('81591', 'Puerto rondón', NULL, NULL, '81'),
('81736', 'Saravena', NULL, NULL, '81'),
('81794', 'Tame', NULL, NULL, '81'),
('85001', 'Yopal', NULL, NULL, '85'),
('85010', 'Aguazul', NULL, NULL, '85'),
('85015', 'Chameza', NULL, NULL, '85'),
('85125', 'Hato corozal', NULL, NULL, '85'),
('85136', 'La salina', NULL, NULL, '85'),
('85139', 'Maní', NULL, NULL, '85'),
('85162', 'Monterrey', NULL, NULL, '85'),
('85225', 'Nunchía', NULL, NULL, '85'),
('85230', 'Orocué', NULL, NULL, '85'),
('85250', 'Paz de ariporo', NULL, NULL, '85'),
('85263', 'Pore', NULL, NULL, '85'),
('85279', 'Recetor', NULL, NULL, '85'),
('85300', 'Sabanalarga', NULL, NULL, '85'),
('85315', 'Sácama', NULL, NULL, '85'),
('85325', 'San luis de palenque', NULL, NULL, '85'),
('85400', 'Támara', NULL, NULL, '85'),
('85410', 'Tauramena', NULL, NULL, '85'),
('85430', 'Trinidad', NULL, NULL, '85'),
('85440', 'Villanueva', NULL, NULL, '85'),
('86001', 'Mocoa', NULL, NULL, '86'),
('86219', 'Colón', NULL, NULL, '86'),
('86320', 'Orito', NULL, NULL, '86'),
('86568', 'Puerto asís', NULL, NULL, '86'),
('86569', 'Puerto caicedo', NULL, NULL, '86'),
('86571', 'Puerto guzmán', NULL, NULL, '86'),
('86573', 'Leguízamo', NULL, NULL, '86'),
('86749', 'Sibundoy', NULL, NULL, '86'),
('86755', 'San francisco', NULL, NULL, '86'),
('86757', 'San miguel', NULL, NULL, '86'),
('86760', 'Santia', NULL, NULL, '86'),
('86865', 'Valle del guamuez', NULL, NULL, '86'),
('86885', 'Villagarzón', NULL, NULL, '86'),
('88001', 'San andrés', NULL, NULL, '88'),
('88564', 'Providencia', NULL, NULL, '88'),
('91001', 'Leticia', NULL, NULL, '91'),
('91263', 'El encanto', NULL, NULL, '91'),
('91405', 'La chorrera', NULL, NULL, '91'),
('91407', 'La pedrera', NULL, NULL, '91'),
('91430', 'La victoria', NULL, NULL, '91'),
('91460', 'Miriti - paraná', NULL, NULL, '91'),
('91530', 'Puerto alegría', NULL, NULL, '91'),
('91536', 'Puerto arica', NULL, NULL, '91'),
('91540', 'Puerto nariño', NULL, NULL, '91'),
('91669', 'Puerto santander', NULL, NULL, '91'),
('91798', 'Tarapacá', NULL, NULL, '91'),
('94001', 'Inírida', NULL, NULL, '94'),
('94343', 'Barranco minas', NULL, NULL, '94'),
('94663', 'Mapiripana', NULL, NULL, '94'),
('94883', 'San felipe', NULL, NULL, '94'),
('94884', 'Puerto colombia', NULL, NULL, '94'),
('94885', 'La guadalupe', NULL, NULL, '94'),
('94886', 'Cacahual', NULL, NULL, '94'),
('94887', 'Pana pana', NULL, NULL, '94'),
('94888', 'Morichal', NULL, NULL, '94'),
('95001', 'San josé del guaviare', NULL, NULL, '95'),
('95015', 'Calamar', NULL, NULL, '95'),
('95025', 'El retorno', NULL, NULL, '95'),
('95200', 'Miraflores', NULL, NULL, '95'),
('97001', 'Mitú', NULL, NULL, '97'),
('97161', 'Caruru', NULL, NULL, '97'),
('97511', 'Pacoa', NULL, NULL, '97'),
('97666', 'Taraira', NULL, NULL, '97'),
('97777', 'Papunaua', NULL, NULL, '97'),
('97889', 'Yavaraté', NULL, NULL, '97'),
('99001', 'Puerto carreño', NULL, NULL, '99'),
('99524', 'La primavera', NULL, NULL, '99'),
('99624', 'Santa rosalía', NULL, NULL, '99'),
('99773', 'Cumaribo', NULL, NULL, '99');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pais`
--

CREATE TABLE `pais` (
  `id` varchar(3) NOT NULL,
  `nombre_español` varchar(50) DEFAULT NULL,
  `nombre_ingles` varchar(50) DEFAULT NULL,
  `nombre_frances` varchar(50) DEFAULT NULL,
  `cod_iso2` varchar(2) DEFAULT NULL,
  `cod_iso3` varchar(3) DEFAULT NULL,
  `cod_phone` varchar(10) DEFAULT NULL,
  `descripcion` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pais`
--

INSERT INTO `pais` (`id`, `nombre_español`, `nombre_ingles`, `nombre_frances`, `cod_iso2`, `cod_iso3`, `cod_phone`, `descripcion`) VALUES
('013', 'Afganistán', 'Afghanistan', 'Afghanistan', 'AF', 'AFG', '93', ''),
('017', 'Albania', 'Albania', 'Albanie', 'AL', 'ALB', '355', ''),
('023', 'Alemania', 'Germany', 'Allemagne', 'DE', 'DEU', '49', ''),
('026', 'Armenia', 'Armenia', 'L\'Arménie', 'AM', 'ARM', '374', ''),
('027', 'Aruba', 'Aruba', 'Aruba', 'AW', 'ABW', '297', ''),
('029', 'Bosnia y Herzegovina', 'Bosnia and Herzegovina', 'Bosnie-Herzégovine', 'BA', 'BIH', '387', ''),
('031', 'Burkina Faso', 'Burkina Faso', 'Burkina Faso', 'BF', 'BFA', '226', ''),
('032', 'Serbia', 'Serbia', 'Serbie', 'RS', 'SRB', '381', ''),
('037', 'Andorra', 'Andorra', 'Andorra', 'AD', 'AND', '376', ''),
('040', 'Angola', 'Angola', 'Angola', 'AO', 'A', '244', ''),
('041', 'Anguila', 'Anguilla', 'Anguilla', 'AI', 'AIA', '1 264', ''),
('043', 'Antigua y Barbuda', 'Antigua and Barbuda', 'Antigua et Barbuda', 'AG', 'ATG', '1 268', ''),
('047', 'Antillas Neerlandesas', 'Netherlands Antilles', 'Antilles Néerlandaises', 'AN', 'ANT', '599', ''),
('053', 'Arabia Saudita', 'Saudi Arabia', 'Arabie Saoudite', 'SA', 'SAU', '966', ''),
('059', 'Algeria', 'Algeria', 'Algérie', 'DZ', 'DZA', '213', ''),
('063', 'Argentina', 'Argentina', 'Argentine', 'AR', 'ARG', '54', ''),
('069', 'Australia', 'Australia', 'Australie', 'AU', 'AUS', '61', ''),
('072', 'Austria', 'Austria', 'Autriche', 'AT', 'AUT', '43', ''),
('074', 'Azerbayán', 'Azerbaijan', 'L\'Azerbaïdjan', 'AZ', 'AZE', '994', ''),
('077', 'Bahamas', 'Bahamas', 'Bahamas', 'BS', 'BHS', '1 242', ''),
('080', 'Bahrein', 'Bahrain', 'Bahreïn', 'BH', 'BHR', '973', ''),
('081', 'Bangladesh', 'Bangladesh', 'Bangladesh', 'BD', 'BGD', '880', ''),
('083', 'Barbados', 'Barbados', 'Barbade', 'BB', 'BRB', '1 246', ''),
('087', 'Bélgica', 'Belgium', 'Belgique', 'BE', 'BEL', '32', ''),
('088', 'Belice', 'Belize', 'Belize', 'BZ', 'BLZ', '501', ''),
('093', 'Birmania', 'Myanmar', 'Myanmar', 'MM', 'MMR', '95', ''),
('097', 'Bolivia', 'Bolivia', 'Bolivie', 'BO', 'BOL', '591', ''),
('101', 'Botsuana', 'Botswana', 'Botswana', 'BW', 'BWA', '267', ''),
('105', 'Brasil', 'Brazil', 'Brésil', 'BR', 'BRA', '55', ''),
('108', 'Brunéi', 'Brunei', 'Brunei', 'BN', 'BRN', '673', ''),
('111', 'Bulgaria', 'Bulgaria', 'Bulgarie', 'BG', 'BGR', '359', ''),
('115', 'Burundi', 'Burundi', 'Burundi', 'BI', 'BDI', '257', ''),
('119', 'Bhután', 'Bhutan', 'Le Bhoutan', 'BT', 'BTN', '975', ''),
('127', 'Cabo Verde', 'Cape Verde', 'Cap-Vert', 'CV', 'CPV', '238', ''),
('145', 'Camerún', 'Cameroon', 'Cameroun', 'CM', 'CMR', '237', ''),
('149', 'Canadá', 'Canada', 'Canada', 'CA', 'CAN', '1', ''),
('159', 'Ciudad del Vaticano', 'Vatican City State', 'Cité du Vatican', 'VA', 'VAT', '39', ''),
('169', 'Colombia', 'Colombia', 'Colombie', 'CO', 'COL', '57', ''),
('173', 'Comoras', 'Comoros', 'Comores', 'KM', 'COM', '269', ''),
('177', 'Congo', 'Congo', 'Congo', 'CG', 'COG', '242', ''),
('187', 'Corea del Norte', 'North Korea', 'Corée du Nord', 'KP', 'PRK', '850', ''),
('190', 'Corea del Sur', 'South Korea', 'Corée du Sud', 'KR', 'KOR', '82', ''),
('193', 'Costa de Marfil', 'Ivory Coast', 'Côte-d\'Ivoire', 'CI', 'CIV', '225', ''),
('196', 'Costa Rica', 'Costa Rica', 'Costa Rica', 'CR', 'CRI', '506', ''),
('198', 'Croacia', 'Croatia', 'Croatie', 'HR', 'HRV', '385', ''),
('199', 'Cuba', 'Cuba', 'Cuba', 'CU', 'CUB', '53', ''),
('203', 'Chad', 'Chad', 'Tchad', 'TD', 'TCD', '235', ''),
('211', 'Chile', 'Chile', 'Chili', 'CL', 'CHL', '56', ''),
('215', 'China', 'China', 'Chine', 'CN', 'CHN', '86', ''),
('218', 'Taiwán', 'Taiwan', 'Taiwan', 'TW', 'TWN', '886', ''),
('221', 'Chipre', 'Cyprus', 'Chypre', 'CY', 'CYP', '357', ''),
('229', 'Benín', 'Benin', 'Bénin', 'BJ', 'BEN', '229', ''),
('232', 'Dinamarca', 'Denmark', 'Danemark', 'DK', 'DNK', '45', ''),
('235', 'Dominica', 'Dominica', 'Dominique', 'DM', 'DMA', '1 767', ''),
('239', 'Ecuador', 'Ecuador', 'Equateur', 'EC', 'ECU', '593', ''),
('240', 'Egipto', 'Egypt', 'Egypte', 'EG', 'EGY', '20', ''),
('242', 'El Salvador', 'El Salvador', 'El Salvador', 'SV', 'SLV', '503', ''),
('243', 'Eritrea', 'Eritrea', 'Erythrée', 'ER', 'ERI', '291', ''),
('244', 'Emiratos Árabes Unidos', 'United Arab Emirates', 'Emirats Arabes Unis', 'AE', 'ARE', '971', ''),
('245', 'España', 'Spain', 'Espagne', 'ES', 'ESP', '34', ''),
('246', 'Eslovaquia', 'Slovakia', 'Slovaquie', 'SK', 'SVK', '421', ''),
('247', 'Eslovenia', 'Slovenia', 'Slovénie', 'SI', 'SVN', '386', ''),
('249', 'Estados Unidos de América', 'United States of America', 'États-Unis d\'Amérique', 'US', 'USA', '1', ''),
('251', 'Estonia', 'Estonia', 'L\'Estonie', 'EE', 'EST', '372', ''),
('253', 'Etiopía', 'Ethiopia', 'Ethiopie', 'ET', 'ETH', '251', ''),
('267', 'Filipinas', 'Philippines', 'Philippines', 'PH', 'PHL', '63', ''),
('271', 'Finlandia', 'Finland', 'Finlande', 'FI', 'FIN', '358', ''),
('275', 'Francia', 'France', 'France', 'FR', 'FRA', '33', ''),
('281', 'Gabón', 'Gabon', 'Gabon', 'GA', 'GAB', '241', ''),
('285', 'Gambia', 'Gambia', 'Gambie', 'GM', 'GMB', '220', ''),
('287', 'Georgia', 'Georgia', 'Géorgie', 'GE', 'GEO', '995', ''),
('289', 'Ghana', 'Ghana', 'Ghana', 'GH', 'GHA', '233', ''),
('293', 'Gibraltar', 'Gibraltar', 'Gibraltar', 'GI', 'GIB', '350', ''),
('297', 'Granada', 'Grenada', 'Grenade', 'GD', 'GRD', '1 473', ''),
('301', 'Grecia', 'Greece', 'Grèce', 'GR', 'GRC', '30', ''),
('305', 'Groenlandia', 'Greenland', 'Groenland', 'GL', 'GRL', '299', ''),
('309', 'Guadalupe', 'Guadeloupe', 'Guadeloupe', 'GP', 'GLP', '', ''),
('313', 'Guam', 'Guam', 'Guam', 'GU', 'GUM', '1 671', ''),
('317', 'Guatemala', 'Guatemala', 'Guatemala', 'GT', 'GTM', '502', ''),
('325', 'Guayana Francesa', 'French Guiana', 'Guyane française', 'GF', 'GUF', '', ''),
('329', 'Guinea', 'Guinea', 'Guinée', 'GN', 'GIN', '224', ''),
('33', 'Isla de Man', 'Isle of Man', 'Ile de Man', 'IM', 'IMN', '44', ''),
('331', 'Guinea Ecuatorial', 'Equatorial Guinea', 'Guinée Equatoriale', 'GQ', 'GNQ', '240', ''),
('334', 'Guinea-Bissau', 'Guinea-Bissau', 'Guinée-Bissau', 'GW', 'GNB', '245', ''),
('337', 'Guyana', 'Guyana', 'Guyane', 'GY', 'GUY', '592', ''),
('341', 'Haití', 'Haiti', 'Haïti', 'HT', 'HTI', '509', ''),
('345', 'Honduras', 'Honduras', 'Honduras', 'HN', 'HND', '504', ''),
('351', 'Hong kong', 'Hong Kong', 'Hong Kong', 'HK', 'HKG', '852', ''),
('355', 'Hungría', 'Hungary', 'Hongrie', 'HU', 'HUN', '36', ''),
('361', 'India', 'India', 'Inde', 'IN', 'IND', '91', ''),
('365', 'Indonesia', 'Indonesia', 'Indonésie', 'ID', 'IDN', '62', ''),
('369', 'Irak', 'Iraq', 'Irak', 'IQ', 'IRQ', '964', ''),
('372', 'Irán', 'Iran', 'Iran', 'IR', 'IRN', '98', ''),
('375', 'Irlanda', 'Ireland', 'Irlande', 'IE', 'IRL', '353', ''),
('379', 'Islandia', 'Iceland', 'Islande', 'IS', 'ISL', '354', ''),
('383', 'Israel', 'Israel', 'Israël', 'IL', 'ISR', '972', ''),
('386', 'Italia', 'Italy', 'Italie', 'IT', 'ITA', '39', ''),
('391', 'Jamaica', 'Jamaica', 'Jamaïque', 'JM', 'JAM', '1 876', ''),
('399', 'Japón', 'Japan', 'Japon', 'JP', 'JPN', '81', ''),
('403', 'Jordania', 'Jordan', 'Jordan', 'JO', 'JOR', '962', ''),
('406', 'Kazajistán', 'Kazakhstan', 'Le Kazakhstan', 'KZ', 'KAZ', '7', ''),
('410', 'Kenia', 'Kenya', 'Kenya', 'KE', 'KEN', '254', ''),
('411', 'Kiribati', 'Kiribati', 'Kiribati', 'KI', 'KIR', '686', ''),
('412', 'Kirgizstán', 'Kyrgyzstan', 'Kirghizstan', 'KG', 'KGZ', '996', ''),
('413', 'Kuwait', 'Kuwait', 'Koweït', 'KW', 'KWT', '965', ''),
('420', 'Laos', 'Laos', 'Laos', 'LA', 'LAO', '856', ''),
('426', 'Lesoto', 'Lesotho', 'Lesotho', 'LS', 'LSO', '266', ''),
('429', 'Letonia', 'Latvia', 'La Lettonie', 'LV', 'LVA', '371', ''),
('431', 'Líbano', 'Lebanon', 'Liban', 'LB', 'LBN', '961', ''),
('434', 'Liberia', 'Liberia', 'Liberia', 'LR', 'LBR', '231', ''),
('438', 'Libia', 'Libya', 'Libye', 'LY', 'LBY', '218', ''),
('440', 'Liechtenstein', 'Liechtenstein', 'Liechtenstein', 'LI', 'LIE', '423', ''),
('443', 'Lituania', 'Lithuania', 'La Lituanie', 'LT', 'LTU', '370', ''),
('445', 'Luxemburgo', 'Luxembourg', 'Luxembourg', 'LU', 'LUX', '352', ''),
('447', 'Macao', 'Macao', 'Macao', 'MO', 'MAC', '853', ''),
('448', 'Macedônia', 'Macedonia', 'Macédoine', 'MK', 'MKD', '389', ''),
('450', 'Madagascar', 'Madagascar', 'Madagascar', 'MG', 'MDG', '261', ''),
('455', 'Malasia', 'Malaysia', 'Malaisie', 'MY', 'MYS', '60', ''),
('458', 'Malawi', 'Malawi', 'Malawi', 'MW', 'MWI', '265', ''),
('464', 'Mali', 'Mali', 'Mali', 'ML', 'MLI', '223', ''),
('467', 'Malta', 'Malta', 'Malte', 'MT', 'MLT', '356', ''),
('474', 'Marruecos', 'Morocco', 'Maroc', 'MA', 'MAR', '212', ''),
('477', 'Martinica', 'Martinique', 'Martinique', 'MQ', 'MTQ', '', ''),
('485', 'Mauricio', 'Mauritius', 'Iles Maurice', 'MU', 'MUS', '230', ''),
('488', 'Mauritania', 'Mauritania', 'Mauritanie', 'MR', 'MRT', '222', ''),
('493', 'México', 'Mexico', 'Mexique', 'MX', 'MEX', '52', ''),
('494', 'Micronesia', 'Estados Federados de', 'Federados Estados de', 'FM', 'FSM', '691', ''),
('496', 'Moldavia', 'Moldova', 'Moldavie', 'MD', 'MDA', '373', ''),
('497', 'Mongolia', 'Mongolia', 'Mongolie', 'MN', 'MNG', '976', ''),
('498', 'Mónaco', 'Monaco', 'Monaco', 'MC', 'MCO', '377', ''),
('501', 'Montserrat', 'Montserrat', 'Montserrat', 'MS', 'MSR', '1 664', ''),
('502', 'Montenegro', 'Montenegro', 'Monténégro', 'ME', 'MNE', '382', ''),
('505', 'Mozambique', 'Mozambique', 'Mozambique', 'MZ', 'MOZ', '258', ''),
('507', 'Namibia', 'Namibia', 'Namibie', 'NA', 'NAM', '264', ''),
('508', 'Nauru', 'Nauru', 'Nauru', 'NR', 'NRU', '674', ''),
('517', 'Nepal', 'Nepal', 'Népal', 'NP', 'NPL', '977', ''),
('521', 'Nicaragua', 'Nicaragua', 'Nicaragua', 'NI', 'NIC', '505', ''),
('525', 'Niger', 'Niger', 'Niger', 'NE', 'NER', '227', ''),
('528', 'Nigeria', 'Nigeria', 'Nigeria', 'NG', 'NGA', '234', ''),
('531', 'Niue', 'Niue', 'Niou', 'NU', 'NIU', '683', ''),
('538', 'Noruega', 'Norway', 'Norvège', 'NO', 'NOR', '47', ''),
('542', 'Nueva Caledonia', 'New Caledonia', 'Nouvelle-Calédonie', 'NC', 'NCL', '687', ''),
('545', 'Papúa Nueva Guinea', 'Papua New Guinea', 'Papouasie-Nouvelle-Guinée', 'PG', 'PNG', '675', ''),
('548', 'Nueva Zelanda', 'New Zealand', 'Nouvelle-Zélande', 'NZ', 'NZL', '64', ''),
('551', 'Vanuatu', 'Vanuatu', 'Vanuatu', 'VU', 'VUT', '678', ''),
('556', 'Omán', 'Oman', 'Oman', 'OM', 'OMN', '968', ''),
('573', 'Países Bajos', 'Netherlands', 'Pays-Bas', 'NL', 'NLD', '31', ''),
('576', 'Pakistán', 'Pakistan', 'Pakistan', 'PK', 'PAK', '92', ''),
('578', 'Palau', 'Palau', 'Palau', 'PW', 'PLW', '680', ''),
('579', 'Palestina', 'Palestine', 'La Palestine', 'PS', 'PSE', '', ''),
('580', 'Panamá', 'Panama', 'Panama', 'PA', 'PAN', '507', ''),
('586', 'Paraguay', 'Paraguay', 'Paraguay', 'PY', 'PRY', '595', ''),
('589', 'Perú', 'Peru', 'Pérou', 'PE', 'PER', '51', ''),
('599', 'Polinesia Francesa', 'French Polynesia', 'Polynésie française', 'PF', 'PYF', '689', ''),
('601', 'Antártida', 'Antarctica', 'L\'Antarctique', 'AQ', 'ATA', '672', ''),
('602', 'Bielorrusia', 'Belarus', 'Biélorussie', 'BY', 'BLR', '375', ''),
('603', 'Camboya', 'Cambodia', 'Cambodge', 'KH', 'KHM', '855', ''),
('604', 'Guernsey', 'Guernsey', 'Guernesey', 'GG', 'GGY', '', ''),
('605', 'Isla Bouvet', 'Bouvet Island', 'Bouvet Island', 'BV', 'BVT', '', ''),
('606', 'Isla de Navidad', 'Christmas Island', 'Christmas Island', 'CX', 'CXR', '61', ''),
('607', 'Isla Norfolk', 'Norfolk Island', 'Île de Norfolk', 'NF', 'NFK', '', ''),
('608', 'Islas Bermudas', 'Bermuda Islands', 'Bermudes', 'BM', 'BMU', '1 441', ''),
('609', 'Islas Caimán', 'Cayman Islands', 'Iles Caïmans', 'KY', 'CYM', '1 345', ''),
('610', 'Islas Cocos (Keeling)', 'Cocos (Keeling) Islands', 'Cocos (Keeling', 'CC', 'CCK', '61', ''),
('611', 'Islas Cook', 'Cook Islands', 'Iles Cook', 'CK', 'COK', '682', ''),
('612', 'Islas de Åland', 'Åland Islands', 'Îles Åland', 'AX', 'ALA', '', ''),
('613', 'Islas Feroe', 'Faroe Islands', 'Iles Féro', 'FO', 'FRO', '298', ''),
('614', 'Islas Georgias del Sur y Sandwich del Sur', 'South Georgia and the South Sandwich Islands', 'Géorgie du Sud et les Îles Sandwich du Sud', 'GS', 'SGS', '', ''),
('615', 'Islas Heard y McDonald', 'Heard Island and McDonald Islands', 'Les îles Heard et McDonald', 'HM', 'HMD', '', ''),
('616', 'Islas Maldivas', 'Maldives', 'Maldives', 'MV', 'MDV', '960', ''),
('617', 'Islas Malvinas', 'Falkland Islands (Malvinas)', 'Iles Falkland (Malvinas', 'FK', 'FLK', '500', ''),
('618', 'Islas Marianas del Norte', 'Northern Mariana Islands', 'Iles Mariannes du Nord', 'MP', 'MNP', '1 670', ''),
('619', 'Islas Marshall', 'Marshall Islands', 'Iles Marshall', 'MH', 'MHL', '692', ''),
('620', 'Islas Pitcairn', 'Pitcairn Islands', 'Iles Pitcairn', 'PN', 'PCN', '870', ''),
('621', 'Islas Salomón', 'Solomon Islands', 'Iles Salomon', 'SB', 'SLB', '677', ''),
('622', 'Islas Turcas y Caicos', 'Turks and Caicos Islands', 'Iles Turques et Caïques', 'TC', 'TCA', '1 649', ''),
('623', 'Islas Ultramarinas Menores de Estados Unidos', 'United States Minor Outlying Islands', 'États-Unis Îles mineures éloignées', 'UM', 'UMI', '', ''),
('624', 'Islas Vírgenes Británicas', 'Virgin Islands', 'Iles Vierges', 'VG', 'VG', '1 284', ''),
('625', 'Islas Vírgenes de los Estados Unidos', 'United States Virgin Islands', 'Îles Vierges américaines', 'VI', 'VIR', '1 340', ''),
('626', 'Jersey', 'Jersey', 'Maillot', 'JE', 'JEY', '', ''),
('627', 'Mayotte', 'Mayotte', 'Mayotte', 'YT', 'MYT', '262', ''),
('628', 'Reino Unido', 'United Kingdom', 'Royaume-Uni', 'GB', 'GBR', '44', ''),
('640', 'República Centroafricana', 'Central African Republic', 'République Centrafricaine', 'CF', 'CAF', '236', ''),
('644', 'República Checa', 'Czech Republic', 'République Tchèque', 'CZ', 'CZE', '420', ''),
('647', 'República Dominicana', 'Dominican Republic', 'République Dominicaine', 'DO', 'DOM', '1 809', ''),
('660', 'Reunión', 'Réunion', 'Réunion', 'RE', 'REU', '', ''),
('665', 'Zimbabue', 'Zimbabwe', 'Zimbabwe', 'ZW', 'ZWE', '263', ''),
('670', 'Rumanía', 'Romania', 'Roumanie', 'RO', 'ROU', '40', ''),
('675', 'Ruanda', 'Rwanda', 'Rwanda', 'RW', 'RWA', '250', ''),
('676', 'Rusia', 'Russia', 'La Russie', 'RU', 'RUS', '7', ''),
('685', 'Sahara Occidental', 'Western Sahara', 'Sahara Occidental', 'EH', 'ESH', '', ''),
('687', 'Samoa', 'Samoa', 'Samoa', 'WS', 'WSM', '685', ''),
('690', 'Samoa Americana', 'American Samoa', 'Les Samoa américaines', 'AS', 'ASM', '1 684', ''),
('695', 'San Cristóbal y Nieves', 'Saint Kitts and Nevis', 'Saint Kitts et Nevis', 'KN', 'KNA', '1 869', ''),
('697', 'San Marino', 'San Marino', 'San Marino', 'SM', 'SMR', '378', ''),
('700', 'San Pedro y Miquelón', 'Saint Pierre and Miquelon', 'Saint-Pierre-et-Miquelon', 'PM', 'SPM', '508', ''),
('705', 'San Vicente y las Granadinas', 'Saint Vincent and the Grenadines', 'Saint-Vincent et Grenadines', 'VC', 'VCT', '1 784', ''),
('710', 'Santa Elena', 'Ascensión y Tristán de Acuña', 'Ascensión y Tristan de Acuña', 'SH', 'SHN', '290', ''),
('715', 'Santa Lucía', 'Saint Lucia', 'Sainte-Lucie', 'LC', 'LCA', '1 758', ''),
('720', 'Santo Tomé y Príncipe', 'Sao Tome and Principe', 'Sao Tomé et Principe', 'ST', 'STP', '239', ''),
('728', 'Senegal', 'Senegal', 'Sénégal', 'SN', 'SEN', '221', ''),
('731', 'Seychelles', 'Seychelles', 'Les Seychelles', 'SC', 'SYC', '248', ''),
('735', 'Sierra Leona', 'Sierra Leone', 'Sierra Leone', 'SL', 'SLE', '232', ''),
('741', 'Singapur', 'Singapore', 'Singapour', 'SG', 'SGP', '65', ''),
('744', 'Siria', 'Syria', 'Syrie', 'SY', 'SYR', '963', ''),
('748', 'Somalia', 'Somalia', 'Somalie', 'SO', 'SOM', '252', ''),
('750', 'Sri lanka', 'Sri Lanka', 'Sri Lanka', 'LK', 'LKA', '94', ''),
('756', 'Sudáfrica', 'South Africa', 'Afrique du Sud', 'ZA', 'ZAF', '27', ''),
('759', 'Sudán', 'Sudan', 'Soudan', 'SD', 'SDN', '249', ''),
('764', 'Suecia', 'Sweden', 'Suède', 'SE', 'SWE', '46', ''),
('767', 'Suiza', 'Switzerland', 'Suisse', 'CH', 'CHE', '41', ''),
('770', 'Surinám', 'Suriname', 'Surinam', 'SR', 'SUR', '597', ''),
('773', 'Swazilandia', 'Swaziland', 'Swaziland', 'SZ', 'SWZ', '268', ''),
('774', 'Tadjikistán', 'Tajikistan', 'Le Tadjikistan', 'TJ', 'TJK', '992', ''),
('776', 'Tailandia', 'Thailand', 'Thaïlande', 'TH', 'THA', '66', ''),
('780', 'Tanzania', 'Tanzania', 'Tanzanie', 'TZ', 'TZA', '255', ''),
('786', 'Territorios Australes y Antárticas Franceses', 'French Southern Territories', 'Terres australes françaises', 'TF', 'ATF', '', ''),
('787', 'Territorio Británico del Océano Índico', 'British Indian Ocean Territory', 'Territoire britannique de l\'océan Indien', 'IO', 'IOT', '', ''),
('788', 'Timor Oriental', 'East Timor', 'Timor-Oriental', 'TL', 'TLS', '670', ''),
('800', 'Togo', 'Togo', 'Togo', 'TG', 'T', '228', ''),
('805', 'Tokelau', 'Tokelau', 'Tokélaou', 'TK', 'TKL', '690', ''),
('810', 'Tonga', 'Tonga', 'Tonga', 'TO', 'TON', '676', ''),
('815', 'Trinidad y Tobago', 'Trinidad and Tobago', 'Trinidad et Tobago', 'TT', 'TTO', '1 868', ''),
('825', 'Turkmenistán', 'Turkmenistan', 'Le Turkménistan', 'TM', 'TKM', '993', ''),
('827', 'Turquía', 'Turkey', 'Turquie', 'TR', 'TUR', '90', ''),
('828', 'Tuvalu', 'Tuvalu', 'Tuvalu', 'TV', 'TUV', '688', ''),
('830', 'Ucrania', 'Ukraine', 'L\'Ukraine', 'UA', 'UKR', '380', ''),
('833', 'Uganda', 'Uganda', 'Ouganda', 'UG', 'UGA', '256', ''),
('845', 'Uruguay', 'Uruguay', 'Uruguay', 'UY', 'URY', '598', ''),
('847', 'Uzbekistán', 'Uzbekistan', 'L\'Ouzbékistan', 'UZ', 'UZB', '998', ''),
('850', 'Venezuela', 'Venezuela', 'Venezuela', 'VE', 'VEN', '58', ''),
('855', 'Vietnam', 'Vietnam', 'Vietnam', 'VN', 'VNM', '84', ''),
('870', 'Fiyi', 'Fiji', 'Fidji', 'FJ', 'FJI', '679', ''),
('875', 'Wallis y Futuna', 'Wallis and Futuna', 'Wallis et Futuna', 'WF', 'WLF', '681', ''),
('880', 'Yemen', 'Yemen', 'Yémen', 'YE', 'YEM', '967', ''),
('890', 'Zambia', 'Zambia', 'Zambie', 'ZM', 'ZMB', '260', ''),
('980', 'San Bartolomé', 'Saint Barthélemy', 'Saint-Barthélemy', 'BL', 'BLM', '590', ''),
('981', 'San Martín (Francia)', 'Saint Martin (French part)', 'Saint-Martin (partie française)', 'MF', 'MAF', '1 599', ''),
('982', 'Svalbard y Jan Mayen', 'Svalbard and Jan Mayen', 'Svalbard et Jan Mayen', 'SJ', 'SJM', '', ''),
('983', 'Tunez', 'Tunisia', 'Tunisie', 'TN', 'TUN', '216', ''),
('984', 'Yibuti', 'Djibouti', 'Djibouti', 'DJ', 'DJI', '253', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--

CREATE TABLE `permiso` (
  `id` bigint(20) NOT NULL,
  `id_rol` int(11) DEFAULT NULL,
  `id_submenu_opcion` int(11) DEFAULT NULL,
  `Id_empresa` int(11) NOT NULL,
  `acciones` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`id`, `id_rol`, `id_submenu_opcion`, `Id_empresa`, `acciones`) VALUES
(1, 1, 4, 1, ''),
(2, 1, 5, 1, ''),
(3, 1, 6, 1, ''),
(4, 1, 7, 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `codigo` varchar(50) NOT NULL,
  `codigo_barra` varchar(100) NOT NULL,
  `descripcion` varchar(256) NOT NULL,
  `foto` longtext NOT NULL,
  `valor_unitario` double NOT NULL,
  `iva` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id`, `id_empresa`, `nombre`, `codigo`, `codigo_barra`, `descripcion`, `foto`, `valor_unitario`, `iva`) VALUES
(1, 1, 'PC', 'PC', 'hfasbfj3hiua1982194723984wdjasidhak', 'negro', 'sdfkdlsfdsljfdskldslnvdskjdlskfjdslfkdslfdslfkds', 2500000, 0),
(2, 2, 'Cocacola', 'CO', 'samdasiudhasidw83', 'negra', 'dsjfdksfhsdkfh85348', 10000, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `id` int(11) NOT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id`, `id_empresa`, `nombre`, `descripcion`) VALUES
(1, 1, 'Administrador', 'Este es el administrador');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submenu`
--

CREATE TABLE `submenu` (
  `id` int(11) NOT NULL,
  `id_menu` tinyint(4) NOT NULL,
  `orden` tinyint(4) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  `icono` varchar(50) DEFAULT NULL,
  `activo` bit(1) NOT NULL,
  `tool_tip_text` varchar(150) DEFAULT NULL,
  `ruta_formulario` varchar(250) DEFAULT NULL,
  `formulario` varchar(100) DEFAULT NULL,
  `acciones` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `submenu`
--

INSERT INTO `submenu` (`id`, `id_menu`, `orden`, `nombre`, `descripcion`, `icono`, `activo`, `tool_tip_text`, `ruta_formulario`, `formulario`, `acciones`) VALUES
(1, 1, 1, 'Información General', 'Sub Menu de descripcion geneal', 'la la-calculator', b'1', NULL, 'InformacionGeneral.html', NULL, '|G|C|E|'),
(2, 4, 1, 'Libros', 'Libros', 'la la-book', b'1', NULL, 'views/GestionarLibros/Libros/Libros.html', NULL, '|N|G|E|C|'),
(3, 4, 2, 'Genero', 'Genero', 'la la-calculator', b'1', NULL, 'views/GestionarLibros/Genero/Genero.html', NULL, '|N|G|E|C|'),
(4, 4, 3, 'Autores', 'Autores', 'la la-user', b'1', NULL, 'views/GestionarLibros/Autores/Autores.html', NULL, '|N|G|E|C|'),
(5, 3, 3, 'Roles', 'Roles', 'la la-calculator', b'1', NULL, 'views/Configuracion/Roles/Roles.html', NULL, '|N|G|E|C|');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `submenuopcion`
--

CREATE TABLE `submenuopcion` (
  `id` int(11) NOT NULL,
  `id_sub_menu` smallint(6) DEFAULT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  `activo` bit(1) DEFAULT NULL,
  `icono` varchar(250) DEFAULT NULL,
  `accion` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `submenuopcion`
--

INSERT INTO `submenuopcion` (`id`, `id_sub_menu`, `nombre`, `descripcion`, `activo`, `icono`, `accion`) VALUES
(4, 5, 'Guardar', 'Guardar', b'1', 'fa fa-save', '|G|'),
(5, 5, 'Atras', 'Atras', b'1', 'fa fa-arrow-circle-left', '|C|'),
(6, 5, 'Eliminar', 'Eliminar', b'1', 'fa fa-trash', '|E|'),
(7, 5, 'Nuevo', 'Nuevo', b'1', 'fa fa-plus-circle', '|N|'),
(8, 2, 'Nuevo', 'Nuevo', b'1', 'fa fa-plus-circle', '|N|'),
(9, 2, 'Guardar', 'Guardar', b'1', 'fa fa-save', '|G|'),
(10, 2, 'Atras', 'Atras', b'1', 'fa fa-arrow-circle-left', '|C|'),
(12, 2, 'Eliminar', 'Eliminar', b'1', 'fa fa-trash', '|E|'),
(13, 3, 'Nuevo', 'Nuevo', b'1', 'fa fa-plus-circle', '|N|'),
(14, 3, 'Guardar', 'Guardar', b'1', 'fa fa-save', '|G|'),
(15, 3, 'Atras', 'Atras', b'1', 'fa fa-arrow-circle-left', '|C|'),
(16, 3, 'Eliminar', 'Eliminar', b'1', 'fa fa-trash', '|E|');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipodocumento`
--

CREATE TABLE `tipodocumento` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  `sigla` char(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id` int(11) NOT NULL,
  `id_empresa` int(11) DEFAULT NULL,
  `primer_nombre` varchar(25) NOT NULL,
  `segundo_nombre` varchar(25) DEFAULT NULL,
  `primer_apellido` varchar(25) NOT NULL,
  `segundo_apellido` varchar(25) NOT NULL,
  `identificacion` varchar(25) NOT NULL,
  `id_tipo_identificacion` int(11) NOT NULL,
  `id_pais` int(11) NOT NULL,
  `id_departamento` int(11) NOT NULL,
  `id_municipio` varchar(5) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `direccion` varchar(250) DEFAULT NULL,
  `correo` varchar(250) DEFAULT NULL,
  `celular` varchar(100) DEFAULT NULL,
  `telefono` varchar(100) DEFAULT NULL,
  `user` varchar(50) NOT NULL,
  `pass` varchar(50) NOT NULL,
  `activo` bit(1) DEFAULT NULL,
  `foto` varchar(50) DEFAULT NULL,
  `id_usuario_registro` int(11) NOT NULL,
  `fecha_registro` datetime NOT NULL,
  `fecha_actualizacion` datetime NOT NULL,
  `tipo_user` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id`, `id_empresa`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `identificacion`, `id_tipo_identificacion`, `id_pais`, `id_departamento`, `id_municipio`, `id_rol`, `direccion`, `correo`, `celular`, `telefono`, `user`, `pass`, `activo`, `foto`, `id_usuario_registro`, `fecha_registro`, `fecha_actualizacion`, `tipo_user`) VALUES
(1, 1, 'Frainer', 'Jose', 'Simarra ', 'Aguilar', '11433846422', 1, 13, 4, '3', 1, 'Este es el primer usuario', 'frainer2013@gmail.com', '3227858583', NULL, 'frainer', 'fs', b'1', NULL, 0, '2021-01-08 17:17:28', '2021-01-04 17:17:28', 'admin');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `bodega`
--
ALTER TABLE `bodega`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `genero`
--
ALTER TABLE `genero`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `libro`
--
ALTER TABLE `libro`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `municipio`
--
ALTER TABLE `municipio`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `pais`
--
ALTER TABLE `pais`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `submenu`
--
ALTER TABLE `submenu`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `submenuopcion`
--
ALTER TABLE `submenuopcion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipodocumento`
--
ALTER TABLE `tipodocumento`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `bodega`
--
ALTER TABLE `bodega`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `genero`
--
ALTER TABLE `genero`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `libro`
--
ALTER TABLE `libro`
  MODIFY `id` int(50) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
