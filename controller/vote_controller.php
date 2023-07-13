<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";


class VoteController extends BaseController
{
    public function vote(){
        $err=array();


        if($_POST["id"]==false)
        {
            array_push($err, "id was not sent");
        }

        if (!($_POST["isyes"] == "true" || $_POST["isyes"] == "false"))
        {
            array_push($err, 'Not a valid "vote" variabe option');
        }
        
        if($err!=[])
        {
            $this->sendResponse(400, [ "message"=>$err]);
        }

        $imagesModel= null;
        
        $isYes=$_POST["isyes"];
        $id = $_POST['id'];
        
        try {
            $imagesModel=  new imagesModel();
        } catch (Exeption $e) {
            array_push($err, $e->getMessage());
        }

        
        try
        {
            $imagesModel->vote($id, $isYes);
        }
        catch(Exception $e)
        {
            array_push($err, $e->getMessage());
        }

        if($err!=[])
        {
            $this->sendResponse(500, [ "message"=>$err]);
        }

        $this->sendResponse(200);
    }
}
?>