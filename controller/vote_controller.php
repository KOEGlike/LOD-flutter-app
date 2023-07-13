<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";


class VoteController extends BaseController
{
    function vote(){
        $err400="";
        $err500="";


        if($_POST["id"]==false)
        {
            $err400.="id was not sent";
        }

        if (!($_POST["isyes"] == "true" || $_POST["isyes"] == "false"))
        {
            $err400.='Nota a valid "vote" variabe option';
        }
        
        if($err500!="")
        {
            $this->sendResponse(200, ["success" => true, "message"=>$err400]);
        }

        $imagesModel= null;
        
        $isYes=$_POST["isyes"];
        $id = $_POST['id'];
        
        try {
            $imagesModel=  new imagesModel();
        } catch (Exeption $e) {
            $err500.=$e->getMessage();
        }

        
        try
        {
            $imagesModel->vote($id, $isYes);
        }
        catch(Exception $e)
        {
            $err500.=$e->getMessage();
        }

        if($err500!="")
        {
            $this->sendResponse(200, ["success" => true, "message"=>$err500]);
        }

        $this->sendResponse(200, ["success" => true]);
    }
}
?>