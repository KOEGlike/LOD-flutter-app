<?php 
require_once getenv('ROOT_PATH') . "/Model/database.php";

class ImagesModel extends DataBase
{
    public function insertImage($originId,$fileName)
    {
        try{
            $this->executeStatemant('INSERT INTO kepek (file_Name, origin_id) VALUES (:name, :origin_id )', 
        [[':name',$file_name],[':origin_id',$originId]]);
        }
        catch(Exception $e)
        {
            throw new Exception($e->getMessage(), 1);  
        }
    }

    public function getImages($originId)
    {
        $images = $this->select("SELECT * FROM kepek WHERE origin_id = :value",[[":value", $SOPid]]);
            return $images;
    }
}
?>