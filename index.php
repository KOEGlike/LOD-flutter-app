<?php 
require_once("inc/bootstrap.php");

$baseController=new BaseController();
$uri=$baseController->getUriSegments();

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