<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/model/LODs_model.php";



class UploadController extends BaseController
{
    function createLOD()
    {
        if ($_POST["name"] == false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "name variable was not sent"]);
        }

        $name = $_POST["name"];
        
        try{
        $LODsModel=new LODsModel;
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
        if ($_FILES["file"] == false && $_POST["id"] == false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "photo and id was not sent"]);
        }
        elseif ($_FILES["file"] == false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "photo was not sent"]);
        }
        elseif ($_POST["id"] == false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "id variable was not sent"]);
        }
        $uploadedPhoto = $_FILES['file'];
        $id = $_POST["id"];
        $target_dir = "images/$id/";
        $targetFile = $target_dir . basename($uploadedPhoto["name"]);
        $imagesModel= new ImagesModel
        $err = "";

        try {
           $imagesModel-> insertImage($id,$uploadedPhoto["name"]);
        } catch (Exception $e) {
            $err.=$e;
        }

        

        // Check if file already exists
        if (file_exists($targetFile))
        {
            $err .= " Sorry, file already exists.";

        }

        // Check file size
        if ($uploadedPhoto["size"]> 26214400)
        {
            $err .= " Sorry, your file is too large.";

        }
        
        

        if (!move_uploaded_file($uploadedPhoto["tmp_name"], $targetFile))
        {
            $err .= " Sorry, the file couldnt be moved to the final location";
        }

        if ($err != "")
        {
            $this->sendResponse(500, ["success" => false, "message" => $err]);
        }
        else
        {
            $this->sendResponse(200, ["success" => true]);
        }
    }
}

?>