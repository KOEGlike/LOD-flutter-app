<?php 
require_once("inc/bootstrap.php");

$baseController=new BaseController();
//$uri=$baseController->getUriSegments();
$uri = parse_url ($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = str_replace("/".explode( 'public_html/', __DIR__)[1]."/", "", parse_url($uri, PHP_URL_PATH)); 
$uri = explode( '/', $uri );

if($uri[0]=="upload"&&$uri[1]=="create"&&count($uri)==2)
{
    $createControler= new UploadController();
    $createControler->createLOD();
}
elseif($uri[0]=="upload"&&$uri[1]="upload"&&count($uri)==2)
{   
    $createControler= new UploadController();
    $createControler->uploadImage();
}
elseif($uri[0]=="get"&&count($uri)==1)
{
    $getControler= new GetController();
    $getControler->getLOD();
}
elseif($uri[0]=="vote"&&count($uri)==1)
{
    $voteControler= new VoteController();
    $voteControler->vote();
}
else{
$baseController->thisEndpointDoseNotExist();
}
?>