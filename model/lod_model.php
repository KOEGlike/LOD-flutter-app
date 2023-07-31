<?php 
$dir=getenv("DOCUMENT_ROOT");
$dir='G:\haacer man\flutter\first_test';//delete
require_once  $dir."/model//database.php";

class LodModel extends DataBase
{
    public function insertNew(string $name) :int
    {
        try{
        $this->executeStatement('INSERT INTO  sopNames(name) VALUES (:name)', [[':name', $name]]);
        }
        catch(Exception $e)
        {
            throw new Exception($e->getMessage(), 1);  
        }

        return $this->conn->lastInsertId();
        
    }

    public function getLOD(int $id) :array
    {
        $LOD=$this->select("SELECT * FROM sopNames WHERE id = :value",[[":value", $id]]);
        return $LOD;
    }
}
?>