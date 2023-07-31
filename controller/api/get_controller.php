<?php 
require_once  "../../model/images_model.php";
require_once  "../../model/lod_model.php";
require_once  "./base_conroller.php";

class GetController extends BaseController{

    public  function getLOD():void
    {
      if($_SERVER["REQUEST_METHOD"] !== "GET")
        {
            $this->methodNotSupported();
        }

      $params=  $this->getQueryStringParams();
      $err = array();
      
      if(!(isset($params['id']) && $params['id']))
      {
       array_push($err, "Id querry param was not set. ") ;
      }
      
      if($err!= "")
      {
        $this-> errorResponse(400, $err);
      }
      
      $id=$params['id'];
      $lod=null;
      $images = null;
      
      try{
        $imagesModel= new ImagesModel();
      }
      catch(Exception $e)
      {
        array_push($err, $e->getMessage()) ;
      }

      try{
        $lodModel= new LodModel();
      }
      catch(Exception $e)
      {
        array_push($err, $e->getMessage()) ;
      }
      
      try{
        $images=  $imagesModel->getImages($id);
      }
      catch(Exception $e)
      {
        array_push($err, $e->getMessage());
      }

      try{
        $lod=$lodModel->getLOD($id);
      }
      catch(Exception $e)
      {
        array_push($err, $e->getMessage()) ;
      }

      if($err!= "")
      {
        $this-> errorResponse(500, $err);
      }

      $this-> sendResponse(200, ["images" => $images, "name" => $lod[0]["name"]]);
    }
}
?>