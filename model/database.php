<?php

class DataBase
{
    public $conn=null;

    public function __construct()
    {
        $servername= getenv('DB_SERVER_NAME');
        $dbname = getenv('DB_NAME');
        $username= getenv('DB_USER_NAME');
        $password=getenv('DB_PASS');

        $servername= 'localhost';//delete
        $dbname = 'id20173908_sopdb';//delete
        $username= 'id20173908_sopuser';//delete
        $password='fkrj(N@8ZBOZ\>_y';//delete

        
        
        try {
            $this->conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
            $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e) {
            throw new Exception("Error Connecting To DB: " . $e->getMessage(), 1);
        }
    }

    public function select(string $query = "" ,array $params = []):array
    {
        try {
            $stmt = $this->executeStatement( $query , $params );
            $result = $$stmt->fetchAll(PDO::FETCH_ASSOC);				
            $stmt->closeCursor();
            return $result;
        } catch(Exception $e) {
            throw New Exception( $e->getMessage() );
        }
        
    }
    
    public function executeStatement(string $query = "",array $params = []):PDOStatement
    {
        try 
        {
            $stmt = $this->conn->prepare($query);
            if ($stmt === false) 
            {
                throw new Exception("Unable to prepare statement: " . $query);
            }

            if ($params) 
            {
                foreach ($params as $param) {
                    $stmt->bindValue($param[0], $param[1]);
                }
            }

            $stmt->execute();
            return $stmt;
        } 
        catch (Exception $e) {
            throw new Exception($e->getMessage());
        }
    }   

}


?>
