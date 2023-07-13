<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/model/LODs_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";



class UploadController extends BaseController
{
    function createLOD()
    {
        if ($_POST["name"] == false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "name variable was not sent"]);
        }

        $name = $_POST["name"];
        
        $LODsModel=null;
        try{
        $LODsModel=new LODsModel();
        }
        catch(Exception $e)
        {
            $this->pdoErrorResponse($e);
        }

        $lastSopId =null;
        
        try
        {
            $lastSopId = $LODsModel->insertNew($name);
        }
        catch(Exception $e)
        {
            $this->pdoErrorResponse($e);
        }
       
        $targetDir = "images/$lastSopId";
        
        try{
        mkdir($targetDir);
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["success" => false, ]);
        }
        
        $this->sendResponse(200, ["success" => true, "id" => $lastSopId]);
    }

    function  uploadImage()
    {
        $err400 = "";
        $err500 = "";
        
        
        if ($_FILES["file"] == false)
        {
            $err400.="Photo was not sent. ";
        }
        elseif ($_POST["id"] == false)
        {
            $err400.="Id variable was not sent. ";
        }
        
        $uploadedPhoto = $_FILES['file'];
        $id = $_POST["id"];
        
        $target_dir = "images/$id/";
        $targetFile = $target_dir . basename($uploadedPhoto["name"]);
        
        $imagesModel=null;

        // Check if file already exists
        if (file_exists($targetFile))
        {
            $err400 .= " Sorry, file already exists.";

        }

        // Check file size
        if ($uploadedPhoto["size"]> 26214400)
        {
            $err400 .= " Sorry, your file is too large.";

        }


        if ($err400 != "")
        {
            $this->sendResponse(500, ["success" => false, "message" => $err400]);
        }

        try
        {
        $imagesModel= new ImagesModel();
        }
        catch(Exception $e){

           $err500.=$e->getMessage();;
        }
        
        try {
            $imagesModel-> insertImage($id,$uploadedPhoto["name"]);
         } catch (Exception $e) {
             $err500.=$e;
         }

        if (!move_uploaded_file($uploadedPhoto["tmp_name"], $targetFile))
        {
            $err500 .= " Sorry, the file couldnt be moved to the final location";
        }

        
        elseif($err500 != "")
        {
            $this->sendResponse(500, ["success" => false, "message" => $err500]);
        }
        
            $this->sendResponse(200, ["success" => true]);
        
    }
}

?>