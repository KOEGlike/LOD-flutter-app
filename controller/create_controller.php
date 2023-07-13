<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/model/LODs_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";



class UploadController extends BaseController
{
    public function createLOD()
    {
        $err=array();
        
        if ($_POST["name"] == false)
        {
            array_push($err, "name variable was not sent");
        }

        if($err!=[])
        {
            $this->errorResponse(400, $err);
        }


        $name = $_POST["name"];
        
        $LODsModel=null;
        try{
        $LODsModel=new LODsModel();
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }

        $lastSopId =null;
        
        try
        {
            $lastSopId = $LODsModel->insertNew($name);
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }
       
        $targetDir = "images/$lastSopId";
        
        try{
        mkdir($targetDir);
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }

        if($err!=[])
        {
            $this->errorResponse(500, $err);
        }
        
        $this->sendResponse(200, [ "id" => $lastSopId]);
    }

    public function  uploadImage()
    {
        $err = array();
        
        
        if ($_FILES["file"] == false)
        {
            array_push($err, "Photo was not sent. ");
        }
        elseif ($_POST["id"] == false)
        {
            array_push($err, "Id variable was not sent. ");
        }
        
        $uploadedPhoto = $_FILES['file'];
        $id = $_POST["id"];
        
        $target_dir = "images/$id/";
        $targetFile = $target_dir . basename($uploadedPhoto["name"]);
        
        $imagesModel=null;

        // Check if file already exists
        if (file_exists($targetFile))
        {
            array_push($err, "Sorry, file already exists.");

        }

        $size=26214400;
        // Check file size
        if ($uploadedPhoto["size"]>$size )
        {
            array_push($err, " Sorry, your file is too large,  its larger than $size bytes.");

        }


        if ($err != [])
        {
            $this->sendResponse(400, [ "message" => $err]);
        }

        try
        {
        $imagesModel= new ImagesModel();
        }
        catch(Exception $e){

            array_push($err, $e->getMessage());
        }
        
        try {
            $imagesModel-> insertImage($id,$uploadedPhoto["name"]);
         } catch (Exception $e) {
            array_push($err, $e->getMessage());
         }

        if (!move_uploaded_file($uploadedPhoto["tmp_name"], $targetFile))
        {
            array_push($err, "Sorry, the file couldnt be moved to the final location");
        }

        
        elseif($err != [])
        {
            $this->sendResponse(500, ["message" => $err]);
        }
        
            $this->sendResponse(200);
        
    }
}

?>