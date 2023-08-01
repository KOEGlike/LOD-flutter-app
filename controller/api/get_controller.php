<?php 
$dir=getenv("ROOT_DIR");

require_once  $dir."/model/images_model.php";
require_once  $dir."/model/lod_model.php";
require_once  $dir."/controller/api/base_controller.php";

class GetController extends BaseController{

    public  function getLOD():void
    {
      if($_SERVER["REQUEST_METHOD"] !== "GET")
        {
            $this->methodNotSupported();
        }

      $params= $_GET;
      $err = array();
      
      if(!(isset($params['id']) || $params['id']))
      {
       array_push($err, "Id querry param was not set.") ;
      }
      elseif(is_int($params['id']))
      {
        array_push($err, "Id querry param is not integer.") ;
      }
      
      if($err!= [])
      {
        $this-> sendResponse(400, ["message" => implode(", ", $err)]);
      }

      $id=$params['id'];
      $lod=null;
      $images = null;
      $imagesModel=null;
      $lodModel=null;
      
      try{
        $imagesModel= new ImagesModel();
      }
      catch(Exception $e)
      {
        $this->sendResponse(500, ["message" => $e->getMessage()]);
        
      }

      try{
        $lodModel= new LodModel();
      }
      catch(Exception $e)
      {
        $this->sendResponse(500, ["message" => $e->getMessage()]);
      }
      
      try{
        $images= $imagesModel->getImages($id);
      }
      catch(Exception $e)
      {
        $this->sendResponse(500, ["message" => $e->getMessage()]);
      }

      try{
        $lod=$lodModel->getLOD($id);
      }
      catch(Exception $e)
      {
        $this->sendResponse(500, ["message" => $e->getMessage()]);;
      }

      

      $this-> sendResponse(200, ["images" => $images, "name" => $lod[0]["name"]]);
    }
}
?>