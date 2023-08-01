<?php 
$dir=getenv("ROOT_DIR");

require_once $dir. "/model/images_model.php";
require_once $dir."/model/lod_model.php";
require_once $dir."/controller/api/base_controller.php";
require_once $dir."/controller/file/base_controller.php";



class UploadController extends BaseController
{
    public function createLOD()
    {
        $dir=getenv("ROOT_DIR");
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
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        try
        {
            $fileController=new BaseFileController();
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        
        
        if (!$_POST["name"] ||!isset($_POST["name"]))
        {
            array_push($err, "Name variable was not sent");
        }

        if($err!=[])
        {
            $this->sendResponse(400, ["message" => implode(", ",$err)]);;
        }

        $name = $_POST["name"];
        
        
        
        try
        {
            $lastSopId = $lodModel->insertNew($name);
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }
       
        $targetDir = $this->$dir."/images/$lastSopId";
        
        try
        {
            $fileController->createFolder($targetDir);
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        
        
        $this->sendResponse(200, [ "id" => $lastSopId]);
    }

    public function  uploadImage()
    {
        $dir=getenv("ROOT_DIR");

        if($_SERVER["REQUEST_METHOD"] !== "POST")
        {
            $this->methodNotSupported();
        }
        
        $err = array();
        
        if (!$_FILES["file"] ||!isset($_FILES["file"]))
        {
            array_push($err, "Photo was not sent. ");
        }
        if (!$_POST["id"] ||!isset($_POST["id"]))
        {
            array_push($err, "Id variable was not sent. ");
        }
        elseif(!is_int($_POST["id"]))
        {
            array_push($err, "Id variable is not an integer. ");
        }
        
        $uploadedPhoto = $_FILES['file'];
        $id = $_POST["id"];
        
        $targetDir = $dir."/images/$id/";
        $targetFile = $targetDir . basename($uploadedPhoto["name"]);
        
        if ($err != [])
        {
            $this->sendResponse(400, [ "message" => implode(", ",$err)]);
        }

        try
        {
        $imagesModel= new ImagesModel();
        }
        catch(Exception $e){

            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        //no reason for try catch rght now, thsi shoul be in the 500 error section, i will implemenitit in the future
        try
        {
            $fileController=new BaseFileController();
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }
        
        if($fileController->checkFile($uploadedPhoto,$targetFile)!=[])
        {
            $this->sendResponse(400, ["message" => implode(", ",$fileController->checkFile($uploadedPhoto,$targetFile))]);
        }

        try 
        {
            $fileController->moveFile($uploadedPhoto,$targetFile);
        } 
        catch (Exception $e) 
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }
        
        try 
        {
            $imagesModel-> insertImage($id,$uploadedPhoto["name"]);
        } 
        catch (Exception $e) 
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        

        
        $this->sendResponse(200);
        
    }
}

?>