<?php 
require_once getenv('ROOT_PATH') . "/model/database.php";

class ImagesModel extends DataBase
{
    public function insertImage(int $originId,string $fileName)
    {
        try{
            $this->executeStatemant('INSERT INTO kepek (file_Name, origin_id) VALUES (:name, :origin_id )', 
        [[':name',$fileName],[':origin_id',$originId]]);
        }
        catch(Exception $e)
        {
            throw new Exception($e->getMessage(), 1);  
        }
    }

    public function getImages(int $originId)
    {
        $images = $this->select("SELECT * FROM kepek WHERE origin_id = :value",[[":value", $originId]]);
            return $images;
    }

    public function vote(int $id,bool $isYes)
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