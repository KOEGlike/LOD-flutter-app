<?php 
require_once getenv('ROOT_PATH') . "/model/images_model.php";
require_once getenv('ROOT_PATH') . "/controller/base_conroller.php";


class VoteController extends BaseController
{
    function vote(){
        $err="";

        if($_POST["id"]==false)
        {
            $this->sendResponse(400, ["success" => false, "message" => "id was not sent"]);
        }

        if (!($_POST["isyes"] == "true" || $_POST["isyes"] == "false"))
        
        {
            $this->sendResponse(400, ["success" => false, "message" => 'NOT A VALID "vote" variabe option']);
        }
        
        $imagesModell= null;
            $isYes=$_POST["isyes"];
        try {
            $imagesModel=  new imagesModel();
        } catch (Exeption $e) {
            $this->pdoErrorResponse($e);
        }

        
        try
        {
            $imagesModel->vote(null, $isYes);
        }
        catch(Exception $e)
        {
            $this->pdoErrorResponse($e);
        }

        $this->sendResponse(200, ["success" => true]);
    }
}
?>