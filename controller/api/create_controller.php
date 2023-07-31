<?php 
$dir=getenv("DOCUMENT_ROOT");
$dir='G:\haacer man\flutter\first_test';//delete

require_once $dir. "/model/images_model.php";
require_once $dir."/model/lod_model.php";
require_once $dir."/controller/api/base_controller.php";
require_once $dir."/controller/file/base_controller.php";



class UploadController extends BaseController
{
    public function createLOD()
    {
        if($_SERVER["REQUEST_METHOD"] !== "POST")
        {
            $this->methodNotSupported();
        }
        
        $err=array();

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

        if($err!=[])
        {
            $this->errorResponse(500, $err);
        }
        
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
        if($_SERVER["REQUEST_METHOD"] !== "POST")
        {
            $this->methodNotSupported();
        }
        
        $err = array();
        
        try
        {
        $imagesModel= new ImagesModel();
        }
        catch(Exception $e){

            array_push($err, $e->getMessage());
        }

        //no reason for try catch rght now, thsi shoul be in the 500 error section, i will implemenitit in the future
        try
        {
            $fileController=new BaseFileController();
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }
        
        if ($err != [])
        {
            $this->sendResponse(400, [ "message" => $err]);
        }
        
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
        
        
        

        //checks if the file has errors and if it has than it merges those errors with the existing errors
        array_merge($err, $fileController->checkFile($uploadedPhoto,$targetFile));


        if ($err != [])
        {
            $this->sendResponse(400, [ "message" => $err]);
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