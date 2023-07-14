<?php 
require_once getenv('ROOT_PATH') . "/model/api/images_model.php";
require_once getenv('ROOT_PATH') . "/modelapi//lod_model.php";
require_once getenv('ROOT_PATH') . "/controller/api/base_conroller.php";
require_once getenv('ROOT_PATH') . "/controller/file/base_conroller.php";



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
        
        try
        {
        $lodModel=new LodModel();
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }

        try
        {
            $fileController=new BaseFileController();
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }
        
        try
        {
            $lastSopId = $lodModel->insertNew($name);
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }
       
        $targetDir = "images/$lastSopId";
        
        try
        {

            $fileController->createFolder($targetDir);
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
        
        $targetDir = "images/$id/";
        $targetFile = $targetDir . basename($uploadedPhoto["name"]);
        
        
        //no reason for try catch rght now, thsi shoul be in the 500 error section, i will implemenitit in the future
        try
        {
            $fileController=new BaseFileController();
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }

        //checks if the file has errors and if it has than it merges those errors with the existing errors
        array_merge($err, $fileController->checkFile($uploadedPhoto,$targetFile));


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
        
        try 
        {
            $imagesModel-> insertImage($id,$uploadedPhoto["name"]);
        } 
        catch (Exception $e) 
        {
            array_push($err, $e->getMessage());
        }

        try 
        {
            $fileController->moveFile($uploadedPhoto,$targetFile);
        } 
        catch (Exception $e) 
        {
            array_push($err, $e->getMessage());
        }

        
        if($err != [])
        {
            $this->sendResponse(500, ["message" => $err]);
        }
        
        $this->sendResponse(200);
        
    }
}

?>