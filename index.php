<?php 
require __DIR__ . "/inc/bootstrap.php";

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$uri = str_replace("/".explode( 'public_html/', __DIR__)[1]."/", "", $uri);
$uri = explode( '/', $uri );
$uri= array_shift($uri);

$deepnes = int(0);

$baseController=new BaseController();

if($uri[$deepnes]=="upload")
{
    $deepnes++;
    $createControler= new UploadController();

    if($uri[$deepnes+1]!=null)
    {
        $createControler->thisEndpointDoseNotExist();
    }

    if($uri[1]=="create")
    {
        $deepnes++;
        $createControler->createLOD();
    }
    elseif($uri[1]="upload")
    {   
        $deepnes++;
        $createControler->uploadImage();
    }
    else{
        $createControler->thisEndpointDoseNotExist();
    }
}
elseif($uri[0]=="get")
{
    $deepnes++;
    $getControler= new GetController();

    if($uri[$deepnes+1]!=null)
    {
        $getControler->thisEndpointDoseNotExist();
    }
    $getControler->getLOD();


}
elseif($uri[0]=="vote")
{
    $deepnes++;
    $voteControler= new VoteController();

    if($uri[$deepnes+1]!=null)
    {
        $voteControler->thisEndpointDoseNotExist();
    }

    $voteControler->vote();

}
else{
$baseController->thisEndpointDoseNotExist();
}




 
?>