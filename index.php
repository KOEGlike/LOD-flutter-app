<?php 
require __DIR__ . "/inc/bootstrap.php";

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
str_replace(__DIR__, "", $uri);
$uri = explode( '/', $uri );



if($uri[0]==) 
?>