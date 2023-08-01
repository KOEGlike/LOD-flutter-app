<?php 
$dir=getenv("ROOT_DIR");

require_once  $dir."/model/images_model.php";
require_once  $dir."/controller/api/base_controller.php";

class VoteController extends BaseController
{
    public function vote(){
        if($_SERVER["REQUEST_METHOD"] !== "POST")
        {
            $this->methodNotSupported();
        }
        
        $err=array();


        if(!$_POST["id"]||!isset($_POST["id"]))
        {
            array_push($err, "id was not sent");
        }
        elseif(!is_numeric($_POST["id"])){
            array_push($err, "id is not intager");
        }

        if(!$_POST["isyes"]&&!isset($_POST["isyes"]))
        {
            array_push($err, "isyes was not sent.");
        }
        elseif (!is_bool($_POST["isyes"]))
        {
            array_push($err, 'isyes is not true or false');
        }
        
        if($err!=[])
        {
            $this->sendResponse(400, [ "message"=>implode(", ", $err)]);
        }
        
        $isYes=$_POST["isyes"];
        $id = $_POST['id'];
        
        try {
            $imagesModel=  new imagesModel();
        } catch (Exception $e) {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }
        try
        {
            $imagesModel->vote($id, $isYes);
        }
        catch(Exception $e)
        {
            $this->sendResponse(500, ["message" => $e->getMessage()]);
        }

        $this->sendResponse(200);
    }
}
?>