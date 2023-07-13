<?php 
require_once getenv('ROOT_PATH') . "/model/database.php";

class LODsModel extends DataBase
{
    public function insertNew($name)
    {
        try{
        $this->executeStatement('INSERT INTO  sopNames(name) VALUES (:name)', [[':name', $name]])
        }
        catch(Exception $e)
        {
            throw new Exception($e->getMessage(), 1);  
        }

        return $conn->lastInsertId();
        
    }

    public function getLOD($id)
    {
        $LOD=$this->select("SELECT * FROM sopNames WHERE id = :value",[[":value", $id]]);
        return $LOD;
    }
}
?>