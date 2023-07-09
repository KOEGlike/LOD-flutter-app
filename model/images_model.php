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

    public function vote($id, $isYes)
    {
        try
            {
                if ($isYes == true)
                {
                    $this->executeStatemant("UPDATE kepek SET votes = votes+1, votes_amount = votes_amount + 1 WHERE id = :id",[[":id", $id]]);
                }
                else
                {
                    $this->executeStatemant("UPDATE kepek SET votes = votes-1, votes_amount = votes_amount + 1 WHERE id = :id",[[":id", $id]]);
                }
                
            }
            catch(Exception $e)
            {
                throw new Exception($e->getMessage(), 1);
                
            }
    }
}
?>