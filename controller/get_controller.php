<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/model/LODs_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";

class GetController extends BaseController{

    public  function getLOD():array
    {
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
      $imagesModel= null;
      $images = null;
      
      try{
        $imagesModel= new ImagesModel();

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
      if($err!= "")
      {
        $this-> errorResponse(500, $err);
      }

      
        $this-> sendResponse(200);
      

    }


}

?>